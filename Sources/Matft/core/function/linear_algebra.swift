//
//  linalg.swift
//  Matft
//
//  Created by AM19A0 on 2020/03/04.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation
import Accelerate

extension Matft.mfarray.linalg{
    /**
        Solve N simultaneous equation. Get x in coef*x = b. Returned mfarray's type will be float but be double in case that  mftype of either coef or b is double.
        - parameters:
            - coef: Coefficients MfArray for N simultaneous equation
            - b: Biases MfArray for N simultaneous equation
        - throws:
        An error of type `MfError.LinAlg.FactorizationError` and `MfError.LinAlgError.singularMatrix`
     
            /*
            //must be flatten....?
            let a = MfArray([[4, 2],
                            [4, 5]])
            let b = MfArray([[2, -7]])
            let x = try! Matft.mfarray.linalg.solve(a, b: b)
            print(x)
            ==> mfarray =
                [[    2.0,        -3.0]], type=Float, shape=[1, 2]
     
            
            //numpy
            >>> a = np.array([[4,2],[4,5]])
            >>> b = np.array([2,-7])
            >>> np.linalg.solve(a,b)
            array([ 2., -3.])
            >>> np.linalg.solve(a,b.T)
            array([ 2., -3.])
            >>> b = np.array([[2,-7]])
            >>> np.linalg.solve(a,b.T)
            array([[ 2.],
                   [-3.]])

                
            */
     */
    public static func solve(_ coef: MfArray, b: MfArray) throws -> MfArray{
        precondition((coef.ndim == 2), "cannot solve non linear simultaneous equations")
        
        let coefShape = coef.shape
        let bShape = b.shape
        
        precondition(b.ndim <= 2, "Invalid b. Dimension must be 1 or 2")
        var dstColNum = 0
        // check argument
        if b.ndim == 1{
            //(m,m)(m)=(m)
            precondition((coefShape[0] == coefShape[1] && bShape[0] == coefShape[0]), "cannot solve (\(coefShape[0]),\(coefShape[1]))(\(bShape[0]))=(\(bShape[0])) problem")
            dstColNum = coef.shape[0]
        }
        else{//ndim == 2
            //(m,m)(m,n)=(m,n)
            precondition((coefShape[0] == coefShape[1] && bShape[0] == coefShape[0]), "cannot solve (\(coefShape[0]),\(coefShape[1]))(\(bShape[0]),\(bShape[1]))=(\(bShape[0]),\(bShape[1])) problem")
            dstColNum = bShape[1] == 1 ? bShape[0] : bShape[1]
        }
                
        let returnedType = StoredType.priority(coef.storedType, b.storedType)
        
        //get column flatten
        let coef_column_major = to_column_major(coef)
        let b_column_major = to_column_major(b)

        switch returnedType{
        case .Float:
            let coefF = coef_column_major.astype(.Float) //even if original one is float, create copy
            let ret = b_column_major.astype(.Float) //even if original one is float, create copy for lapack calculation

            try coefF.withDataUnsafeMBPtrT(datatype: Float.self){
                coefptr in
                try ret.withDataUnsafeMBPtrT(datatype: Float.self){
                    try solve_by_lapack(copiedCoefPtr: coefptr.baseAddress!, coef.shape[0], $0.baseAddress!, dstColNum, sgesv_)
                }
            }
            
            
            return ret
            
        case .Double:
            let coefD = coef_column_major.astype(.Double) //even if original one is float, create copy
            let ret = b.astype(.Double) //even if original one is float, create copy
            
            try coefD.withDataUnsafeMBPtrT(datatype: Double.self){
                coefptr in
                try ret.withDataUnsafeMBPtrT(datatype: Double.self){
                    try solve_by_lapack(copiedCoefPtr: coefptr.baseAddress!, coef.shape[0], $0.baseAddress!, dstColNum, dgesv_)
                }
            }
            
            return ret
        }
    }
    
    /**
       Get last 2 dim's NxN mfarray's inverse. Returned mfarray's type will be float but be double in case that mftype of mfarray is double.
       - parameters:
           - mfarray: mfarray
       - throws:
       An error of type `MfError.LinAlg.FactorizationError` and `MfError.LinAlgError.singularMatrix`
    */
    public static func inv(_ mfarray: MfArray) throws -> MfArray{
        let shape = mfarray.shape
        precondition(mfarray.ndim > 1, "cannot get an inverse matrix from 1-d mfarray")
        precondition(shape[mfarray.ndim - 1] == shape[mfarray.ndim - 2], "Last 2 dimensions of the mfarray must be square")
        
        switch mfarray.storedType {
        case .Float:
            let newmfdata = try withDummyDataMRPtr(.Float, storedSize: mfarray.size){
                dstptr in
                let dstptrF = dstptr.bindMemory(to: Float.self, capacity: mfarray.size)
                
                try _withNNStackedColumnMajorPtr(mfarray: mfarray, type: Float.self){
                    srcptr, squaredSize, offset in
                    //LU decomposition
                    var IPIV = try LU_by_lapack(squaredSize, squaredSize, srcdstptr: srcptr, lapack_func: sgetrf_)
                    
                    //calculate inv
                    try inv_by_lapack(squaredSize, srcdstptr: srcptr, &IPIV, lapack_func: sgetri_)
                    
                    //move
                    (dstptrF + offset).moveAssign(from: srcptr, count: squaredSize*squaredSize)
                }
            }
            
            let newmfstructure = withDummyShapeStridesMBPtr(mfarray.ndim){
                [unowned mfarray] (shapeptr, stridesptr) in
                
                //shape
                mfarray.withShapeUnsafeMBPtr{
                    [unowned mfarray] in
                    shapeptr.baseAddress!.assign(from: $0.baseAddress!, count: mfarray.ndim)
                }
                
                //strides
                let newstridesptr = shape2strides(shapeptr, mforder: .Row)
                stridesptr.baseAddress!.moveAssign(from: newstridesptr.baseAddress!, count: mfarray.ndim)
                
                newstridesptr.deallocate()
            }
            
            return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
            
        case .Double:
            let newmfdata = try withDummyDataMRPtr(.Double, storedSize: mfarray.size){
                dstptr in
                let dstptrD = dstptr.bindMemory(to: Double.self, capacity: mfarray.size)
                
                try _withNNStackedColumnMajorPtr(mfarray: mfarray, type: Double.self){
                    srcptr, squaredSize, offset in
                    //LU decomposition
                    var IPIV = try LU_by_lapack(squaredSize, squaredSize, srcdstptr: srcptr, lapack_func: dgetrf_)
                    
                    //calculate inv
                    try inv_by_lapack(squaredSize, srcdstptr: srcptr, &IPIV, lapack_func: dgetri_)
                    
                    //move
                    (dstptrD + offset).moveAssign(from: srcptr, count: squaredSize*squaredSize)
                }
            }
            
            let newmfstructure = withDummyShapeStridesMBPtr(mfarray.ndim){
                [unowned mfarray] (shapeptr, stridesptr) in
                
                //shape
                mfarray.withShapeUnsafeMBPtr{
                    [unowned mfarray] in
                    shapeptr.baseAddress!.assign(from: $0.baseAddress!, count: mfarray.ndim)
                }
                
                //strides
                let newstridesptr = shape2strides(shapeptr, mforder: .Row)
                stridesptr.baseAddress!.moveAssign(from: newstridesptr.baseAddress!, count: mfarray.ndim)
                
                newstridesptr.deallocate()
            }
            
            return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
        }

    }
    
    /**
       Get last 2 dim's NxN mfarray's determinant. Returned mfarray's type will be float but be double in case that mftype of mfarray is double.
       - parameters:
           - mfarray: mfarray
       - throws:
       An error of type `MfError.LinAlg.FactorizationError` and `MfError.LinAlgError.singularMatrix`
    */
    public static func det(_ mfarray: MfArray) throws -> MfArray{
        let shape = mfarray.shape
        precondition(mfarray.ndim > 1, "cannot get a determinant from 1-d mfarray")
        precondition(shape[mfarray.ndim - 1] == shape[mfarray.ndim - 2], "Last 2 dimensions of the mfarray must be square")
        
        let retSize = mfarray.size / (shape[mfarray.ndim - 1] * shape[mfarray.ndim - 1])
        switch mfarray.storedType {
        case .Float:
            let newmfdata = try withDummyDataMRPtr(.Float, storedSize: retSize){
                dstptr in
                let dstptrF = dstptr.bindMemory(to: Float.self, capacity: retSize)
                
                var dstoffset = 0
                try _withNNStackedColumnMajorPtr(mfarray: mfarray, type: Float.self){
                    srcptr, squaredSize, offset in
                    //LU decomposition
                    let IPIV = try LU_by_lapack(squaredSize, squaredSize, srcdstptr: srcptr, lapack_func: sgetrf_)
                    
                    //calculate L and U's determinant
                    //Note that L and U's determinant are calculated by product of diagonal elements
                    // L's determinant is always one
                    //ref: https://stackoverflow.com/questions/47315471/compute-determinant-from-lu-decomposition-in-lapack
                    var det = Float(1)
                    for i in 0..<squaredSize{
                        det *= IPIV[i] != __CLPK_integer(i+1) ? srcptr.advanced(by: i + i*squaredSize).pointee : -(srcptr.advanced(by: i + i*squaredSize).pointee)
                    }
                    
                    //move
                    (dstptrF + dstoffset).moveAssign(from: &det, count: 1)
                    dstoffset += 1
                }
            }
            let retndim = mfarray.ndim - 2 != 0 ? mfarray.ndim - 2 : 1
            let newmfstructure = withDummyShapeStridesMBPtr(retndim){
                [unowned mfarray] (shapeptr, stridesptr) in
                
                //shape
                if mfarray.ndim - 2 != 0{
                    mfarray.withShapeUnsafeMBPtr{
                        shapeptr.baseAddress!.assign(from: $0.baseAddress!, count: retndim)
                    }
                    
                    //strides
                    let newstridesptr = shape2strides(shapeptr, mforder: .Row)
                    stridesptr.baseAddress!.moveAssign(from: newstridesptr.baseAddress!, count: retndim)
                    
                    newstridesptr.deallocate()
                }
                else{
                    shapeptr[0] = 1
                    stridesptr[0] = 1
                }
                
            }
            
            return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
            
        case .Double:
            let newmfdata = try withDummyDataMRPtr(.Double, storedSize: retSize){
                dstptr in
                let dstptrF = dstptr.bindMemory(to: Double.self, capacity: retSize)
                
                var dstoffset = 0
                try _withNNStackedColumnMajorPtr(mfarray: mfarray, type: Double.self){
                    srcptr, squaredSize, offset in
                    //LU decomposition
                    let IPIV = try LU_by_lapack(squaredSize, squaredSize, srcdstptr: srcptr, lapack_func: dgetrf_)
                    
                    //calculate L and U's determinant
                    //Note that L and U's determinant are calculated by product of diagonal elements
                    // L's determinant is always one
                    //ref: https://stackoverflow.com/questions/47315471/compute-determinant-from-lu-decomposition-in-lapack
                    var det = Double(1)
                    for i in 0..<squaredSize{
                        det *= IPIV[i] != __CLPK_integer(i+1) ? srcptr.advanced(by: i + i*squaredSize).pointee : -(srcptr.advanced(by: i + i*squaredSize).pointee)
                    }
                    
                    //move
                    (dstptrF + dstoffset).moveAssign(from: &det, count: 1)
                    dstoffset += 1
                }
            }
            let retndim = mfarray.ndim - 2 != 0 ? mfarray.ndim - 2 : 1
            let newmfstructure = withDummyShapeStridesMBPtr(retndim){
                [unowned mfarray] (shapeptr, stridesptr) in
                
                //shape
                if mfarray.ndim - 2 != 0{
                    mfarray.withShapeUnsafeMBPtr{
                        shapeptr.baseAddress!.assign(from: $0.baseAddress!, count: retndim)
                    }
                    
                    //strides
                    let newstridesptr = shape2strides(shapeptr, mforder: .Row)
                    stridesptr.baseAddress!.moveAssign(from: newstridesptr.baseAddress!, count: retndim)
                    
                    newstridesptr.deallocate()
                }
                else{
                    shapeptr[0] = 1
                    stridesptr[0] = 1
                }
                
            }
            return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
        }

    }
}

/**
    - Important: This function for last shape is NxN
 */
fileprivate func _withNNStackedColumnMajorPtr<T: MfStorable>(mfarray: MfArray, type: T.Type, _ body: (UnsafeMutablePointer<T>, Int, Int) throws -> Void) rethrows -> Void{
    let shape = mfarray.shape
    let squaredSize = shape[mfarray.ndim - 1]
    let matricesNum = mfarray.size / (squaredSize * squaredSize)
    
    // get stacked row major and copy
    let rowmajorMfarray = to_row_major(mfarray)
    var offset = 0
    try rowmajorMfarray.withDataUnsafeMBPtrT(datatype: T.self){
        for _ in 0..<matricesNum{
            try body($0.baseAddress! + offset, squaredSize, offset)
            
            offset += squaredSize * squaredSize
        }
    }
}