//
//  vDSP.swift
//  Matft
//
//  Created by Junnosuke Kado on 2020/02/27.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation
import Accelerate
import CoreGraphics

internal typealias vDSP_convert_func<T, U> = (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<U>, vDSP_Stride, vDSP_Length) -> Void

// vDSP_ctoz or vDSP_ztoc
internal typealias vDSP_convertz_func<T, U> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<U>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_biopvv_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void
internal typealias vDSP_biopzvv_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_biopvs_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void
internal typealias vDSP_biopzvs_func<T, U> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<U>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_biopsv_func<T> = (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void
internal typealias vDSP_biopzsv_func<T, U> = (UnsafePointer<T>, UnsafePointer<U>, UnsafePointer<U>, vDSP_Length) -> Void

internal typealias vDSP_vcmprs_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_vminmg_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_viclip_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>,  UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_clip_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length, UnsafeMutablePointer<vDSP_Length>, UnsafeMutablePointer<vDSP_Length>) -> Void

internal typealias vDSP_sort_func<T> = (UnsafeMutablePointer<T>, vDSP_Length, Int32) -> Void

internal typealias vDSP_argsort_func<T> = (UnsafePointer<T>, UnsafeMutablePointer<vDSP_Length>, UnsafeMutablePointer<vDSP_Length>, vDSP_Length, Int32) -> Void

internal typealias vDSP_stats_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Length) -> Void

internal typealias vDSP_stats_index_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, UnsafeMutablePointer<vDSP_Length>, vDSP_Length) -> Void


internal typealias vDSP_math_func<T, U> = vDSP_convert_func<T, U>

internal typealias vDSP_vgathr_func<T> = (UnsafePointer<T>, UnsafePointer<vDSP_Length>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_dotpr_func<T> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Length) -> Void

internal typealias vDSP_z2r_func<T, U> = (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<U>, vDSP_Stride, vDSP_Length) -> Void

internal typealias vDSP_fft_zrop_func<T> = (FFTSetup, UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, vDSP_Length, FFTDirection) -> Void

@inline(__always)
internal func vDSP_zvmul_(_ __A: UnsafePointer<DSPSplitComplex>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<DSPSplitComplex>, _ __IB: vDSP_Stride, _ __C: UnsafePointer<DSPSplitComplex>, _ __IC: vDSP_Stride, _ __N: vDSP_Length) -> Void{
    vDSP_zvmul(__A, __IA, __B, __IB, __C, __IC, __N, Int32(1))
}
@inline(__always)
internal func vDSP_zvmulD_(_ __A: UnsafePointer<DSPDoubleSplitComplex>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<DSPDoubleSplitComplex>, _ __IB: vDSP_Stride, _ __C: UnsafePointer<DSPDoubleSplitComplex>, _ __IC: vDSP_Stride, _ __N: vDSP_Length) -> Void{
    vDSP_zvmulD(__A, __IA, __B, __IB, __C, __IC, __N, Int32(1))
}

/// Wrapper of vDSP conversion function
/// - Parameters:
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - size: A size to be copied
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_convert<T, U>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ dstptr: UnsafeMutablePointer<U>, _ dstStride: Int, _ vDSP_func: vDSP_convert_func<T, U>){
    vDSP_func(srcptr, vDSP_Stride(srcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP conversion function
/// - Parameters:
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - size: A size to be copied
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_convertz<T, U>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ dstptr: UnsafePointer<U>, _ dstStride: Int, _ vDSP_func: vDSP_convertz_func<T, U>){
    vDSP_func(srcptr, vDSP_Stride(srcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary operation function
/// - Parameters:
///   - size: A size
///   - lsrcptr: A left  source pointer
///   - lsrcStride: A left source stride
///   - rsrcptr: A right source pointer
///   - rsrcStride: A right source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopvv<T>(_ size: Int, _ lsrcptr: UnsafePointer<T>, _ lsrcStride: Int, _ rsrcptr: UnsafePointer<T>, _ rsrcStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_biopvv_func<T>){
    vDSP_func(rsrcptr, vDSP_Stride(rsrcStride), lsrcptr, vDSP_Stride(lsrcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary operation function
/// - Parameters:
///   - size: A size
///   - lsrcptr: A left  source pointer
///   - lsrcStride: A left source stride
///   - rsrcptr: A right source pointer
///   - rsrcStride: A right source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopzvv<T>(_ size: Int, _ lsrcptr: UnsafePointer<T>, _ lsrcStride: Int, _ rsrcptr: UnsafePointer<T>, _ rsrcStride: Int, _ dstptr: UnsafePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_biopzvv_func<T>){
    vDSP_func(rsrcptr, vDSP_Stride(rsrcStride), lsrcptr, vDSP_Stride(lsrcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary operation function
/// - Parameters:
///   - size: A size
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - scalar: A source scalar pointer
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopvs<T>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ scalar: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_biopvs_func<T>){
    vDSP_func(srcptr, vDSP_Stride(srcStride), scalar, dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary complex operation function
/// - Parameters:
///   - size: A size
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - scalar: A source scalar pointer
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopzvs<T: vDSP_ComplexTypable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ realptr: UnsafePointer<T.T>, _ realStride: Int, _ dstptr: UnsafePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_biopzvs_func<T, T.T>){
    vDSP_func(srcptr, vDSP_Stride(srcStride), realptr, vDSP_Stride(realStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary operation function
/// - Parameters:
///   - size: A size
///   - scalar: A source scalar pointer
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopsv<T>(_ size: Int, _ scalar: UnsafePointer<T>, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_biopsv_func<T>){
    vDSP_func(scalar, srcptr, vDSP_Stride(srcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP binary operation function
/// - Parameters:
///   - size: A size
///   - scalar: A source scalar pointer
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_biopzsv<T: vDSP_ComplexTypable>(_ size: Int, _ scalar: UnsafePointer<T.T>, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafePointer<T>, _ vDSP_func: vDSP_biopzsv_func<T.T, T>){
    var arrscalar = Array(repeating: scalar.pointee, count: size)
    vDSP_func(&arrscalar, srcptr, dstptr, vDSP_Length(size))
}

/// Wrapper of vDSP boolean conversion function
/// - Parameters:
///   - size: A size to be converted
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - vDSP_vminmg_func: The vDSP vminmg function
///   - vDSP_viclip_func: The vDSP viclip function
@inline(__always)
internal func wrap_vDSP_toBool<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_vminmg_func: vDSP_vminmg_func<T>, _ vDSP_viclip_func: vDSP_viclip_func<T>){
    // if |src| <= 1  => dst = |src|
    //    |src| > 1   => dst = 1
    // Note that the 0<= dst <= 1
    var one = T.from(1)
    vDSP_vminmg_func(srcptr, vDSP_Stride(1), &one, vDSP_Stride(0), dstptr, vDSP_Stride(1), vDSP_Length(size))
    
    var zero = T.zero
    one = T.from(1)
    // if src <= 0, 1 <= src   => dst = src
    //    0 < src <= 1         => dst = 1
    vDSP_viclip_func(dstptr, vDSP_Stride(1), &zero, &one, dstptr, vDSP_Stride(1), vDSP_Length(size))
}

/// Wrapper of vDSP boolean conversion function
/// - Parameters:
///   - size: A size to be converted
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - vDSP_vminmg_func: The vDSP vminmg function
///   - vDSP_viclip_func: The vDSP viclip function
@inline(__always)
internal func wrap_vDSP_toIBool<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_vminmg_func: vDSP_vminmg_func<T>, _ vDSP_viclip_func: vDSP_viclip_func<T>, _ vDSP_addvs_func: vDSP_biopvs_func<T>, _ vForce_abs_func: vForce_math_func<T>){
    var i32size = Int32(size)
    // if |src| <= 1  => dst = |src|
    //    |src| > 1   => dst = 1
    // Note that the 0<= dst <= 1
    var one = T.from(1)
    vDSP_vminmg_func(srcptr, vDSP_Stride(1), &one, vDSP_Stride(0), dstptr, vDSP_Stride(1), vDSP_Length(size))
    
    var zero = T.zero
    one = T.from(1)
    // if src <= 0, 1 <= src   => dst = src
    //    0 < src <= 1         => dst = 1
    vDSP_viclip_func(dstptr, vDSP_Stride(1), &zero, &one, dstptr, vDSP_Stride(1), vDSP_Length(size))
    
    one = T.from(-1)
    vDSP_addvs_func(dstptr, vDSP_Stride(1), &one, dstptr, vDSP_Stride(1), vDSP_Length(size))
    
    vForce_abs_func(dstptr, dstptr, &i32size)
}


/// Wrapper of vDSP sign generation function
/// - Parameters:
///   - size: A size to be converted
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - vDSP_vminmg_func: The vDSP vminmg function
///   - vDSP_viclip_func: The vDSP viclip function
///   - vForce_copysign_func: The vForce copysign function
@inline(__always)
internal func wrap_vDSP_sign<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_vminmg_func: vDSP_vminmg_func<T>, _ vDSP_viclip_func: vDSP_viclip_func<T>, _ vForce_copysign_func: vForce_copysign_func<T>){
    var i32size = Int32(size)
    
    // if |src| <= 1  => dst = |src|
    //    |src| > 1   => dst = 1
    // Note that the 0<= dst <= 1
    var one = T.from(1)
    vDSP_vminmg_func(srcptr, vDSP_Stride(1), &one, vDSP_Stride(0), dstptr, vDSP_Stride(1), vDSP_Length(size))
    
    var zero = T.zero
    one = T.from(1)
    // if src <= 0, 1 <= src   => dst = src
    //    0 < src <= 1         => dst = 1
    vDSP_viclip_func(dstptr, vDSP_Stride(1), &zero, &one, dstptr, vDSP_Stride(1), vDSP_Length(size))
    vForce_copysign_func(dstptr, dstptr, srcptr, &i32size)
}

/// Wrapper of vDSP clip function
/// - Parameters:
///   - size: A size to be converted
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - vDSP_clip_func: The vDSP clip function
@inline(__always)
internal func wrap_vDSP_clip<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ minptr: UnsafePointer<T>, _ maxptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_clip_func: vDSP_clip_func<T>){
    var mincount = vDSP_Length(0)
    var maxcount = vDSP_Length(0)
    
    vDSP_clip_func(srcptr, vDSP_Stride(1), minptr, maxptr, dstptr, vDSP_Stride(1), vDSP_Length(size), &mincount, &maxcount)
}

/// Wrapper of vDSP sort function
/// - Parameters:
///   - size: A size to be copied
///   - srcdstptr: A source pointer
///   - order: MfSortOrder
///   - vDSP_func: The vDSP sort function
@inline(__always)
internal func wrap_vDSP_sort<T>(_ size: Int, _ srcdstptr: UnsafeMutablePointer<T>, _ order: MfSortOrder, _ vDSP_func: vDSP_sort_func<T>){
    vDSP_func(srcdstptr, vDSP_Length(size), order.rawValue)
}

/// Wrapper of vDSP argsort function
/// - Parameters:
///   - size: A size to be copied
///   - srcptr: A source pointer
///   - dstptr: A destination pointer
///   - order: MfSortOrder
///   - vDSP_func: The vDSP argsort function
@inline(__always)
internal func wrap_vDSP_argsort<T>(_ size: Int, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<UInt>, _ order: MfSortOrder, _ vDSP_func: vDSP_argsort_func<T>){
    var tmp = Array<vDSP_Length>(repeating: 0, count: size)
    vDSP_func(srcptr, dstptr, &tmp, vDSP_Length(size), order.rawValue)
}

/// Wrapper of vDSP stats function
/// - Parameters:
///   - size: A size to be copied
///   - srcptr: A source pointer
///   - stride: A stride
///   - dstptr: A destination pointer
///   - vDSP_func: The vDSP stats function
@inline(__always)
internal func wrap_vDSP_stats<T>(_ size: Int, _ srcptr: UnsafePointer<T>, _ stride: Int, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_func: vDSP_stats_func<T>){
    vDSP_func(srcptr, vDSP_Stride(stride), dstptr, vDSP_Length(size))
}

/// Wrapper of vDSP stats index function
/// - Parameters:
///   - size: A size to be copied
///   - srcptr: A source pointer
///   - stride: A stride
///   - dstptr: A destination pointer
///   - vDSP_func: The vDSP stats index function
@inline(__always)
internal func wrap_vDSP_stats_index<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ stride: Int, _ dstptr: UnsafeMutablePointer<UInt>, _ vDSP_func: vDSP_stats_index_func<T>){
    var tmp = Array(repeating: T.zero, count: size)
    vDSP_func(srcptr, vDSP_Stride(stride), &tmp, dstptr, vDSP_Length(size))
}

/// Wrapper of vDSP compress function
/// - Parameters:
///   - size: A size to be copied
///   - srcptr: A source pointer
///   - srcStride: A source stride
///   - indptr: A indices pointer
///   - indStride: A indices stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP cmprs function
@inline(__always)
internal func wrap_vDSP_cmprs<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ indptr: UnsafePointer<T>, _ indStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_vcmprs_func<T>){
    vDSP_func(srcptr, vDSP_Stride(srcStride), indptr, vDSP_Stride(indStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP gather function
/// - Parameters:
///   - size: A size to be copied
///   - srcptr: A source pointer
///   - indptr: A indices pointer
///   - indStride: A indices stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - vDSP_func: The vDSP cmprs function
@inline(__always)
internal func wrap_vDSP_gathr<T: MfStorable>(_ size: Int, _ srcptr: UnsafePointer<T>, _ indptr: UnsafePointer<vDSP_Length>, _ indStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ vDSP_func: vDSP_vgathr_func<T>){
    vDSP_func(srcptr, indptr, vDSP_Stride(indStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(size))
}

/// Wrapper of vDSP dot product operation function
/// - Parameters:
///   - size: A size
///   - lsrcptr: A left  source pointer
///   - lsrcStride: A left source stride
///   - rsrcptr: A right source pointer
///   - rsrcStride: A right source stride
///   - dstptr: A destination pointer
///   - vDSP_func: The vDSP conversion function
@inline(__always)
internal func wrap_vDSP_dotpr<T>(_ size: Int, _ lsrcptr: UnsafePointer<T>, _ lsrcStride: Int, _ rsrcptr: UnsafePointer<T>, _ rsrcStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ vDSP_func: vDSP_dotpr_func<T>){
    vDSP_func(lsrcptr, vDSP_Stride(lsrcStride), rsrcptr, vDSP_Stride(rsrcStride), dstptr, vDSP_Length(size))
}

/// Wrapper of vDSP fft operation function
/// - Parameters:
///   - log2N: The base 2 exponent of the number of elements to process. For example, to process 1024 elements, specify 10 for parameter Log2N.
///   - srcptr: A source pointer
///   - srcStride: A left source stride
///   - dstptr: A destination pointer
///   - dstStride: A destination stride
///   - dstptr: A destination pointer
///   - isForward: Whether to be forward mode or not.
///   - vDSP_func: The vDSP real fft function
@inline(__always)
internal func wrap_vDSP_fft_zr<T>(_ log2N: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ dstptr: UnsafePointer<T>, _ dstStride: Int, _ isForward: Bool, _ vDSP_func: vDSP_fft_zrop_func<T>){
    let setup = vDSP_create_fftsetup(vDSP_Length(log2N), FFTRadix(kFFTRadix2))!// TODO: raise error
    let direction = isForward ? kFFTDirection_Forward : kFFTDirection_Inverse
    vDSP_func(setup, srcptr, vDSP_Stride(srcStride), dstptr, vDSP_Stride(dstStride), vDSP_Length(log2N), FFTDirection(direction))
    vDSP_destroy_fftsetup(setup)
}

/// Convert type and contiguous mfarray
/// - Parameters:
///   - src_mfarray: An input mfarray
///   - mftype: The new mftype
///   - mforder: The order
///   - vDSP_func: vDSP_convert_func
/// - Returns: Pre operated mfarray
internal func contiguous_and_astype_by_vDSP<T: MfStorable, U: MfStorable>(_ src_mfarray: MfArray, mftype: MfType, mforder: MfOrder, vDSP_func: vDSP_convert_func<T, U>) -> MfArray{
    var ret_shape = src_mfarray.shape
    let ret_strides = shape2strides(&ret_shape, mforder: mforder)
    
    let newdata = MfData(size: src_mfarray.size, mftype: mftype)
    
    newdata.withUnsafeMutableStartPointer(datatype: U.self){
        dstptrU in
        src_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned src_mfarray] srcptrT in
            
            for vDSPPrams in OptOffsetParamsSequence(shape: ret_shape, bigger_strides: ret_strides, smaller_strides: src_mfarray.strides){
                
                wrap_vDSP_convert(vDSPPrams.blocksize, srcptrT + vDSPPrams.s_offset, vDSPPrams.s_stride, dstptrU + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
            }
            
        }
    }
    
    let newstructure = MfStructure(shape: ret_shape, strides: ret_strides)
    
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Convert type and contiguous mfarray
/// - Parameters:
///   - src_mfarray: An input mfarray
///   - mftype: The new mftype
///   - mforder: The order
///   - vDSP_func: vDSP_convertz_func
/// - Returns: Pre operated mfarray
internal func zcontiguous_and_astype_by_vDSP<T: vDSP_ComplexTypable, U: vDSP_ComplexTypable>(_ src_mfarray: MfArray, mftype: MfType, mforder: MfOrder, src_type: T.Type, dst_type: U.Type,  vDSP_func: vDSP_convert_func<T.T, U.T>) -> MfArray{
    var ret_shape = src_mfarray.shape
    let ret_strides = shape2strides(&ret_shape, mforder: mforder)
    
    let newdata = MfData(size: src_mfarray.size, mftype: mftype, complex: true)
    
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: U.self){
        dstptrU in
        let dstptrr = dstptrU.pointee.realp
        let dstptri = dstptrU.pointee.imagp
        src_mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned src_mfarray] srcptrT in
            let srcptrr = srcptrT.pointee.realp
            let srcptri = srcptrT.pointee.imagp
            
            for vDSPPrams in OptOffsetParamsSequence(shape: ret_shape, bigger_strides: ret_strides, smaller_strides: src_mfarray.strides){
                
                wrap_vDSP_convert(vDSPPrams.blocksize, srcptrr + vDSPPrams.s_offset, vDSPPrams.s_stride, dstptrr + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                wrap_vDSP_convert(vDSPPrams.blocksize, srcptri + vDSPPrams.s_offset, vDSPPrams.s_stride, dstptri + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
            }
            
        }
    }
    
    let newstructure = MfStructure(shape: ret_shape, strides: ret_strides)
    
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Copy mfarray by vDSP
/// - Parameters:
///   - mfarray: The source mfarray
///   - mforder: The order
///   - vDSP_func: vDSP_copy_function
internal func zcontiguous_by_vDSP<T: vDSP_ComplexTypable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convertz_func<T, T>, mforder: MfOrder) -> MfArray{
    let shape = mfarray.shape
    
    let newdata = MfData(size: mfarray.size, mftype: mfarray.mftype, complex: true)
    let newstructure = MfStructure(shape: shape, mforder: mforder)

    let bigger_strides = newstructure.strides
    let smaller_strides = mfarray.strides
    
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptr in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            srcptr in
            for vDSPPrams in OptOffsetParamsSequence(shape: shape, bigger_strides: bigger_strides, smaller_strides: smaller_strides){
                var dst = dstptr +++ vDSPPrams.b_offset
                var src = srcptr +++ vDSPPrams.s_offset
                wrap_vDSP_convertz(vDSPPrams.blocksize, &src, vDSPPrams.s_stride, &dst, vDSPPrams.b_stride, vDSP_func)
            }
        }
    }
    
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Pre operation mfarray by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - vDSP_func: vDSP_convert_func
/// - Returns: Pre operated mfarray
internal func preop_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convert_func<T, T>) -> MfArray{
    //return mfarray must be either row or column major
    var mfarray = mfarray
    //print(mfarray)
    mfarray = check_contiguous(mfarray)
    //print(mfarray)
    //print(mfarray.strides)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_convert(mfarray.storedSize, $0, 1, dstptrT, 1, vDSP_func)
            //vDSP_func($0.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(mfarray.storedSize))
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// ZPre operation mfarray by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - vDSP_func: vDSP_convert_func
/// - Returns: Pre operated mfarray
internal func zpreop_by_vDSP<T: vDSP_ComplexTypable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convertz_func<T, T>) -> MfArray{
    //return mfarray must be either row or column major
    var mfarray = mfarray
    //print(mfarray)
    mfarray = check_contiguous(mfarray)
    //print(mfarray)
    //print(mfarray.strides)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype, complex: true)
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_convertz(mfarray.storedSize, $0, 1, dstptrT, 1, vDSP_func)
            //vDSP_func($0.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(mfarray.storedSize))
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Phase operation mfarray by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - vDSP_func: vDSP_z2r_func
/// - Returns: Pre operated mfarray
internal func z2r_by_vDSP<T: vDSP_ComplexTypable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convert_func<T, T.T>) -> MfArray{
    //return mfarray must be either row or column major
    var mfarray = mfarray
    //print(mfarray)
    mfarray = check_contiguous(mfarray)
    //print(mfarray)
    //print(mfarray.strides)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype, complex: false)
    newdata.withUnsafeMutableStartPointer(datatype: T.T.self){
        dstptrT in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_convert(mfarray.storedSize, $0, 1, dstptrT, 1, vDSP_func)
            //vDSP_func($0.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(mfarray.storedSize))
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Conjugate operation mfarray by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - vDSP_func: vDSP_conjugate_func
/// - Returns: Pre operated mfarray
internal func conjugate_by_vDSP<T: vDSP_ComplexTypable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convertz_func<T, T>) -> MfArray{
    //return mfarray must be either row or column major
    var mfarray = mfarray
    //print(mfarray)
    mfarray = check_contiguous(mfarray)
    //print(mfarray)
    //print(mfarray.strides)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype, complex: true)
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_convertz(mfarray.storedSize, $0, 1, dstptrT, 1, vDSP_func)
            //vDSP_func($0.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(mfarray.storedSize))
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Math operation mfarray by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - vDSP_func: vDSP_convert_func
/// - Returns: Math operated mfarray
internal func math_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ vDSP_func: vDSP_convert_func<T, T>) -> MfArray{
    return preop_by_vDSP(mfarray, vDSP_func)
}

/// Binary operation by vDSP
/// - Parameters:
///   - l_mfarray: The left mfarray
///   - r_scalr: The right scalar
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopvs_by_vDSP<T: MfStorable>(_ l_mfarray: MfArray, _ r_scalar: T, _ vDSP_func: vDSP_biopvs_func<T>) -> MfArray{
    var mfarray = l_mfarray
    var r_scalar = r_scalar
    
    mfarray = check_contiguous(mfarray)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_biopvs(mfarray.storedSize, $0, 1, &r_scalar, dstptrT, 1, vDSP_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// ZBinary operation by vDSP
/// - Parameters:
///   - l_mfarray: The left mfarray
///   - r_scalr: The right scalar
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopzvs_by_vDSP<T: vDSP_ComplexTypable>(_ l_mfarray: MfArray, _ r_scalar: T.T, _ vDSP_func: vDSP_biopzvs_func<T, T.T>) -> MfArray{
    var mfarray = l_mfarray
    var r_scalar = r_scalar
    
    mfarray = check_contiguous(mfarray)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype, complex: true)
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_biopzvs(mfarray.storedSize, $0, 1, &r_scalar, 0, dstptrT, 1, vDSP_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}


/// Binary operation by vDSP
/// - Parameters:
///   - l_scalar: The left scalar
///   - r_mfarray: The right mfarray
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopsv_by_vDSP<T: MfStorable>(_ l_scalar: T, _ r_mfarray: MfArray, _ vDSP_func: vDSP_biopsv_func<T>) -> MfArray{
    var mfarray = r_mfarray
    var l_scalar = l_scalar
    
    mfarray = check_contiguous(mfarray)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_biopsv(mfarray.storedSize, &l_scalar, $0, 1, dstptrT, 1, vDSP_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// ZBinary operation by vDSP
/// - Parameters:
///   - l_scalar: The left scalar
///   - r_mfarray: The right mfarray
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopzsv_by_vDSP<T: vDSP_ComplexTypable>(_ l_scalar: T.T, _ r_mfarray: MfArray, _ vDSP_func: vDSP_biopzsv_func<T.T, T>) -> MfArray{
    var mfarray = r_mfarray
    var l_scalar = l_scalar
    
    mfarray = check_contiguous(mfarray)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype, complex: true)
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_biopzsv(mfarray.storedSize, &l_scalar, $0, dstptrT, vDSP_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}


/// Binary operation by vDSP
/// - Parameters:
///   - l_mfarray: The left mfarray
///   - r_mfarray: The right mfarray
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopvv_by_vDSP<T: MfStorable>(_ l_mfarray: MfArray, _ r_mfarray: MfArray, vDSP_func: vDSP_biopvv_func<T>) -> MfArray{
    // biggerL: flag whether l is bigger than r
    //return mfarray must be either row or column major
    let (l_mfarray, r_mfarray, biggerL, retsize) = check_biop_contiguous(l_mfarray, r_mfarray, .Row, convertL: true)
    
    let newdata = MfData(size: retsize, mftype: l_mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        l_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned l_mfarray] (lptr) in
            r_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                [unowned r_mfarray] (rptr) in
                //print(l_mfarray, r_mfarray)
                //print(l_mfarray.storedSize, r_mfarray.storedSize)
                //print(biggerL)
                if biggerL{// l is bigger
                    for vDSPPrams in OptOffsetParamsSequence(shape: l_mfarray.shape, bigger_strides: l_mfarray.strides, smaller_strides: r_mfarray.strides){
                        /*
                        let bptr = bptr.baseAddress! + vDSPPrams.b_offset
                        let sptr = sptr.baseAddress! + vDSPPrams.s_offset
                        dstptrT = dstptrT + vDSPPrams.b_offset*/
                        wrap_vDSP_biopvv(vDSPPrams.blocksize, lptr + vDSPPrams.b_offset, vDSPPrams.b_stride, rptr + vDSPPrams.s_offset, vDSPPrams.s_stride, dstptrT + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                        //print(vDSPPrams.blocksize, vDSPPrams.b_offset,vDSPPrams.b_stride,vDSPPrams.s_offset, vDSPPrams.s_stride)
                    }
                }
                else{// r is bigger
                    for vDSPPrams in OptOffsetParamsSequence(shape: r_mfarray.shape, bigger_strides: r_mfarray.strides, smaller_strides: l_mfarray.strides){
                        wrap_vDSP_biopvv(vDSPPrams.blocksize, lptr + vDSPPrams.s_offset, vDSPPrams.s_stride, rptr + vDSPPrams.b_offset, vDSPPrams.b_stride, dstptrT + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                        //print(vDSPPrams.blocksize, vDSPPrams.b_offset,vDSPPrams.b_stride,vDSPPrams.s_offset, vDSPPrams.s_stride)
                    }
                }
            }
        }
    }
    
    let newstructure: MfStructure
    if biggerL{
        newstructure = MfStructure(shape: l_mfarray.shape, strides: l_mfarray.strides)
    }
    else{
        newstructure = MfStructure(shape: r_mfarray.shape, strides: r_mfarray.strides)
    }

    return MfArray(mfdata: newdata, mfstructure: newstructure)
}


/// Binary operation by vDSP
/// - Parameters:
///   - l_mfarray: The left mfarray
///   - r_mfarray: The right mfarray
///   - vDSP_func: The vDSP biop function
/// - Returns: The result mfarray
internal func biopzvv_by_vDSP<T: vDSP_ComplexTypable>(_ l_mfarray: MfArray, _ r_mfarray: MfArray, vDSP_func: vDSP_biopzvv_func<T>) -> MfArray{
    // biggerL: flag whether l is bigger than r
    //return mfarray must be either row or column major
    let (l_mfarray, r_mfarray, biggerL, retsize) = check_biop_contiguous(l_mfarray, r_mfarray, .Row, convertL: true)

    let newdata = MfData(size: retsize, mftype: l_mfarray.mftype, complex: true)
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
        dstptrT in
        l_mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            [unowned l_mfarray] (lptr) in
            r_mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
                [unowned r_mfarray] (rptr) in
                if biggerL{// l is bigger
                    for vDSPPrams in OptOffsetParamsSequence(shape: l_mfarray.shape, bigger_strides: l_mfarray.strides, smaller_strides: r_mfarray.strides){
                        var lhs = lptr +++ vDSPPrams.b_offset
                        var rhs = rptr +++ vDSPPrams.s_offset
                        var dst = dstptrT +++ vDSPPrams.b_offset
                        wrap_vDSP_biopzvv(vDSPPrams.blocksize, &lhs, vDSPPrams.b_stride, &rhs, vDSPPrams.s_stride, &dst, vDSPPrams.b_stride, vDSP_func)
                    }
                }
                else{// r is bigger
                    for vDSPPrams in OptOffsetParamsSequence(shape: r_mfarray.shape, bigger_strides: r_mfarray.strides, smaller_strides: l_mfarray.strides){
                        var lhs = lptr +++ vDSPPrams.s_offset
                        var rhs = rptr +++ vDSPPrams.b_offset
                        var dst = dstptrT +++ vDSPPrams.b_offset
                        wrap_vDSP_biopzvv(vDSPPrams.blocksize, &lhs, vDSPPrams.s_stride, &rhs, vDSPPrams.b_stride, &dst, vDSPPrams.b_stride, vDSP_func)
                    }
                }
            }
        }
    }
    
    let newstructure: MfStructure
    if biggerL{
        newstructure = MfStructure(shape: l_mfarray.shape, strides: l_mfarray.strides)
    }
    else{
        newstructure = MfStructure(shape: r_mfarray.shape, strides: r_mfarray.strides)
    }

    return MfArray(mfdata: newdata, mfstructure: newstructure)
}


/// Stats operation by vDSP
/// - Parameters:
///   - typedMfarray: An input **typed** mfarray. Returned mfarray will have same type.
///   - axis; An axis index
///   - keepDims: Whether to keep dimension or not
///   - vDSP_func: The vDSP stats function
/// - Returns: The stats operated mfarray
internal func stats_by_vDSP<T: MfStorable>(_ typedMfarray: MfArray, axis: Int?, keepDims: Bool, vDSP_func: vDSP_stats_func<T>) -> MfArray{
    
    let mfarray = check_contiguous(typedMfarray, .Row)
    
    if let axis = axis, mfarray.ndim > 1{
        let axis = get_positive_axis(axis, ndim: mfarray.ndim)
        var ret_shape = mfarray.shape
        let count = ret_shape.remove(at: axis)
        var ret_strides = mfarray.strides
        //remove and get stride at given axis
        let stride = ret_strides.remove(at: axis)
        
        let ret_size = shape2size(&ret_shape)
        
        let newdata = MfData(size: ret_size, mftype: mfarray.mftype)
        var dst_offset = 0
        
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                for flat in FlattenIndSequence(shape: &ret_shape, strides: &ret_strides){
                    wrap_vDSP_stats(count, $0 + flat.flattenIndex, stride, dstptrT + dst_offset, vDSP_func)
                    dst_offset += 1
                }
            }
        }
        
        let newstructure = MfStructure(shape: ret_shape, mforder: .Row)
        
        let ret = MfArray(mfdata: newdata, mfstructure: newstructure)
        return keepDims ? Matft.expand_dims(ret, axis: axis) : ret
    }
    else{
        let newdata = MfData(size: 1, mftype: mfarray.mftype)
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                wrap_vDSP_stats(mfarray.size, $0, 1, dstptrT, vDSP_func)
            }
        }
        
        let ret_shape = keepDims ? Array(repeating: 1, count: mfarray.ndim) : [1]
        let newstructure = MfStructure(shape: ret_shape, mforder: .Row)
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
}

/// Stats operation by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - axis; An axis index
///   - keepDims: Whether to keep dimension or not
///   - vDSP_func: The vDSP stats function
/// - Returns: The sorted mfarray
internal func stats_index_by_vDSP<T: MfStorable>(_ mfarray: MfArray, axis: Int?, keepDims: Bool, vDSP_func: vDSP_stats_index_func<T>) -> MfArray{
    
    let mfarray = check_contiguous(mfarray, .Row)
    
    if let axis = axis, mfarray.ndim > 1{
        let axis = get_positive_axis(axis, ndim: mfarray.ndim)
        var ret_shape = mfarray.shape
        let count = ret_shape.remove(at: axis)
        var ret_strides = mfarray.strides
        //remove and get stride at given axis
        let stride = ret_strides.remove(at: axis)
        let ui_stride = UInt(stride)
        
        let ret_size = shape2size(&ret_shape)
        
        let newdata = MfData(size: ret_size, mftype: mfarray.mftype)
        var dst_offset = 0
        
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                for flat in FlattenIndSequence(shape: &ret_shape, strides: &ret_strides){
                    var uival = UInt.zero
                    wrap_vDSP_stats_index(count, $0 + flat.flattenIndex, stride, &uival, vDSP_func)
                    (dstptrT + dst_offset).pointee = T.from(uival / ui_stride)
                    
                    dst_offset += 1//koko
                }
            }
        }
        
        let newstructure = MfStructure(shape: ret_shape, mforder: .Row)
        
        let ret = MfArray(mfdata: newdata, mfstructure: newstructure)
        return keepDims ? Matft.expand_dims(ret, axis: axis) : ret
    }
    else{
        let newdata = MfData(size: 1, mftype: mfarray.mftype)
        var uival = UInt.zero
        
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                wrap_vDSP_stats_index(mfarray.size, $0, 1, &uival, vDSP_func)
            }
            dstptrT.pointee = T.from(uival)
        }
        
        let ret_shape = keepDims ? Array(repeating: 1, count: mfarray.ndim) : [1]
        let newstructure = MfStructure(shape: ret_shape, mforder: .Row)
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
}


/// Sort operation by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - axis; An axis index
///   - order: MfSortOrder
///   - vDSP_func: The vDSP sort function
/// - Returns: The sorted mfarray
internal func sort_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ axis: Int, _ order: MfSortOrder, _ vDSP_func: vDSP_sort_func<T>) -> MfArray{
    let retndim = mfarray.ndim
    let count = mfarray.shape[axis]
    
    let lastaxis = retndim - 1
    // move lastaxis and given axis and align order
    let srcdst_mfarray = mfarray.moveaxis(src: axis, dst: lastaxis).to_contiguous(mforder: .Row)

    var offset = 0
    
    srcdst_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
        srcdstptr in
        for _ in 0..<mfarray.storedSize / count{
            wrap_vDSP_sort(count, srcdstptr + offset, order, vDSP_func)
            offset += count
        }
    }
    
    // re-move axis and lastaxis
    return srcdst_mfarray.moveaxis(src: lastaxis, dst: axis)
}


/// Argsort operation by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - axis; An axis index
///   - order: MfSortOrder
///   - vDSP_func: The vDSP sort function
/// - Returns: The sorted mfarray
internal func argsort_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ axis: Int, _ order: MfSortOrder, _ vDSP_func: vDSP_argsort_func<T>) -> MfArray{

    let count = mfarray.shape[axis]
    
    let lastaxis = mfarray.ndim - 1
    // move lastaxis and given axis and align order
    let srcmfarray = mfarray.moveaxis(src: axis, dst: lastaxis).to_contiguous(mforder: .Row)
    var retShape = srcmfarray.shape
    
    var offset = 0

    let retSize = shape2size(&retShape)
    let newdata = MfData(size: retSize, mftype: .Int)
    newdata.withUnsafeMutableStartPointer(datatype: Float.self){
        dstptrF in
        srcmfarray.withUnsafeMutableStartPointer(datatype: T.self){
            srcptr in
            
            for _ in 0..<mfarray.storedSize / count{
                var uiarray = Array<UInt>(stride(from: 0, to: UInt(count), by: 1))
                //let srcptr = stride >= 0 ? srcptr.baseAddress! : srcptr.baseAddress! - mfarray.offsetIndex
                wrap_vDSP_argsort(count, srcptr + offset, &uiarray, order, vDSP_func)
                
                // TODO: refactor
                //convert dataptr(int) to float
                var flarray = uiarray.map{ Float($0) }
                flarray.withUnsafeMutableBufferPointer{
                    (dstptrF + offset).moveUpdate(from: $0.baseAddress!, count: count)
                }
                
                offset += count
            }
            
        }
    }
    
    let newstructure = MfStructure(shape: retShape, mforder: .Row)
    
    let ret = MfArray(mfdata: newdata, mfstructure: newstructure)
    
    // re-move axis and lastaxis
    return ret.moveaxis(src: lastaxis, dst: axis)
    
}


/// Clip operation by vDSP
/// - Parameters:
///   - mfarray: An input mfarray
///   - minval: The minimum value
///   - maxval: The maximum value
///   - vDSP_func: The vDSP clip function
/// - Returns: The clipped mfarray
internal func clip_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ minval: T, _ maxval: T, _ vDSP_func: vDSP_clip_func<T>) -> MfArray{
    //return mfarray must be either row or column major
    var mfarray = mfarray
    var minval = minval
    var maxval = maxval
    
    //print(mfarray)
    mfarray = check_contiguous(mfarray)
    //print(mfarray)
    //print(mfarray.strides)
    
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            [unowned mfarray] in
            wrap_vDSP_clip(mfarray.storedSize, $0, &minval, &maxval, dstptrT, vDSP_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Generate sign by vDSP
/// - Parameters:
///    - mfarray: An input mfarray
///    - vDSP_vminmg_func: vDSP_vminmg function
///    - vDSP_viclip_func: vDSP_viclip function
///    - vForce_copysign_func: vForce_copysign function
/// - Returns: Converted mfarray
internal func sign_by_vDSP<T: MfStorable>(_ mfarray: MfArray, vDSP_vminmg_func: vDSP_vminmg_func<T>, vDSP_viclip_func: vDSP_viclip_func<T>, vForce_copysign_func: vForce_copysign_func<T>) -> MfArray{
    let mfarray = check_contiguous(mfarray)
        
    let size = mfarray.storedSize
    let newdata = MfData(size: mfarray.storedSize, mftype: mfarray.mftype)
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            wrap_vDSP_sign(size, $0, dstptrT, vDSP_vminmg_func, vDSP_viclip_func,
                vForce_copysign_func)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Boolean conversion by vDSP
/// - Parameter mfarray: An input mfarray
/// - Returns: Converted mfarray
internal func toBool_by_vDSP(_ mfarray: MfArray) -> MfArray{
    assert(mfarray.storedType == .Float, "Must be bool")
    
    let size = mfarray.storedSize
    let newdata = MfData(size: mfarray.storedSize, mftype: .Bool)
    newdata.withUnsafeMutableStartPointer(datatype: Float.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: Float.self){
            wrap_vDSP_toBool(size, $0, dstptrT, vDSP_vminmg, vDSP_viclip)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Boolean conversion by vDSP
/// - Parameter mfarray: An input mfarray
/// - Returns: Converted mfarray
internal func toIBool_by_vDSP(_ mfarray: MfArray) -> MfArray{
    assert(mfarray.storedType == .Float, "Must be bool")
    
    let size = mfarray.storedSize
    let newdata = MfData(size: mfarray.storedSize, mftype: .Bool)
    newdata.withUnsafeMutableStartPointer(datatype: Float.self){
        dstptrT in
        mfarray.withUnsafeMutableStartPointer(datatype: Float.self){
            wrap_vDSP_toIBool(size, $0, dstptrT, vDSP_vminmg, vDSP_viclip, vDSP_vsadd, vvfabsf)
        }
    }
    
    let newstructure = MfStructure(shape: mfarray.shape, strides: mfarray.strides)
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

// generate(arange)
/*
internal typealias vDSP_arange_func<T> = (UnsafePointer<T>, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

fileprivate func _arange_run<T: MfStorable>(_ startptr: UnsafePointer<T>, _ srcptr: UnsafePointer<T>, _ dstptr: UnsafeMutablePointer<T>, _ stride: Int, _ count: Int, _ vDSP_func: vDSP_arange_func<T>){
    vDSP_func(startptr, srcptr, dstptr, vDSP_Stride(stride), vDSP_Length(count))
}

internal func arange_by_vDSP<T: MfStorable>(_ start: T, _ by: T, _ count: Int, _ mftype: MfType, vDSP_func: vDSP_arange_func<T>) -> MfArray{
    let newdata = withDummyDataMRPtr(mftype, storedSize: count){
        dstptr in
        let dstptrT = dstptr.bindMemory(to: T.self, capacity: count)
        var start = start
        var by = by
        _arange_run(&start, &by, dstptrT, 1, count, vDSP_func)
    }
    
    let newstructure = withDummyShapeStridesMBPtr(retShape.count){
        shapeptr, stridesptr in
        retShape.withUnsafeMutableBufferPointer{
            shapeptr.baseAddress!.moveAssign(from: $0.baseAddress!, count: shapeptr.count)
        }
        
        let newstrides = shape2strides(shapeptr, mforder: .Row)
        stridesptr.baseAddress!.moveAssign(from: newstrides.baseAddress!, count: shapeptr.count)
        
        newstrides.deallocate()
    }
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}
*/

//TODO: ret dim = ori dim - ind dim + 1.

/// Boolean getter operation mfarray by vDSP
/// - Parameters:
///   - src_mfarray: An input mfarray
///   - indices: An indices boolean mfarray
///   - vDSP_func: vDSP_vcmprs_func
/// - Returns: Result mfarray
internal func boolget_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ indices: MfArray, _ vDSP_func: vDSP_vcmprs_func<T>) -> MfArray{
    assert(indices.mftype == .Bool, "must be bool")
    /*
     Note that returned shape must be (true number in original indices, (mfarray's shape - original indices' shape));
     i.e. returned dim = 1(=true number in original indices) + mfarray's dim - indices' dim
     */
    let true_num = Float.toInt(indices.sum().scalar(Float.self)!)
    let orig_ind_dim = indices.ndim
    
    // broadcast
    let indices = bool_broadcast_to(indices, shape: mfarray.shape)

    // must be row major
    let indicesT: MfArray
    switch mfarray.storedType {
    case .Float:
        indicesT = indices // indices must have float raw values
    case .Double:
        indicesT = indices.astype(.Double)
    }
    //let mfarray = check_contiguous(mfarray, .Row)
    
    
    let lastShape = Array(mfarray.shape.suffix(mfarray.ndim - orig_ind_dim))
    var retShape = [true_num] + lastShape
    let retSize = shape2size(&retShape)
    
    if mfarray.isReal{
        let newdata = MfData(size: retSize, mftype: mfarray.mftype)
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            indicesT.withUnsafeMutableStartPointer(datatype: T.self){
                //[unowned indicesT](indptr) in
                indptr in
                // note that indices and mfarray is row contiguous
                mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                    srcptr in
                    
                    for vDSPPrams in OptOffsetParamsSequence(shape: indicesT.shape, bigger_strides: indicesT.strides, smaller_strides: mfarray.strides){
                        wrap_vDSP_cmprs(vDSPPrams.blocksize, srcptr + vDSPPrams.s_offset, vDSPPrams.s_stride, indptr + vDSPPrams.b_offset, vDSPPrams.b_stride, dstptrT + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                    }
                    //vDSP_func(srcptr.baseAddress!, vDSP_Stride(1), indptr.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(indicesT.size))
                }
            }
        }
        
        
        let newstructure = MfStructure(shape: retShape, mforder: .Row)
        
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
    else{
        let newdata = MfData(size: retSize, mftype: mfarray.mftype, complex: true)
        newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.vDSPComplexType.self){
            dstptrT in
            indicesT.withUnsafeMutableStartPointer(datatype: T.self){
                //[unowned indicesT](indptr) in
                indptr in
                // note that indices and mfarray is row contiguous
                mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.vDSPComplexType.self){
                    srcptr in
                    let srcptrr = srcptr.pointee.realp as! UnsafeMutablePointer<T>
                    let srcptri = srcptr.pointee.imagp as! UnsafeMutablePointer<T>
                    let dstptrTr = dstptrT.pointee.realp as! UnsafeMutablePointer<T>
                    let dstptrTi = dstptrT.pointee.imagp as! UnsafeMutablePointer<T>
                    
                    for vDSPPrams in OptOffsetParamsSequence(shape: indicesT.shape, bigger_strides: indicesT.strides, smaller_strides: mfarray.strides){
                        wrap_vDSP_cmprs(vDSPPrams.blocksize, srcptrr + vDSPPrams.s_offset, vDSPPrams.s_stride, indptr + vDSPPrams.b_offset, vDSPPrams.b_stride, dstptrTr + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                        wrap_vDSP_cmprs(vDSPPrams.blocksize, srcptri + vDSPPrams.s_offset, vDSPPrams.s_stride, indptr + vDSPPrams.b_offset, vDSPPrams.b_stride, dstptrTi + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                    }
                    //vDSP_func(srcptr.baseAddress!, vDSP_Stride(1), indptr.baseAddress!, vDSP_Stride(1), dstptrT, vDSP_Stride(1), vDSP_Length(indicesT.size))
                }
            }
        }
        
        
        let newstructure = MfStructure(shape: retShape, mforder: .Row)
        
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
}


/// Getter function for the fancy indexing on a given Interger indices.
/// - Parameters:
///   - mfarray: An inpu mfarray. Must be 1d
///   - indices: An input Interger indices array
///   - vDSP_func: vDSP_vgathr_func
/// - Returns: The mfarray
internal func fancy1dgetcol_by_vDSP<T: MfStorable>(_ mfarray: MfArray, _ indices: MfArray, _ vDSP_func: vDSP_vgathr_func<T>) -> MfArray{
    assert(indices.mftype == .Int, "must be int")
    assert(mfarray.ndim == 1, "must be 1d")
    // fancy indexing
    // note that if not assignment, returned copy value not view.
    /*
     >>> a = np.arange(9).reshape(3,3)
     >>> a
     array([[0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]])
     >>> a[[1,2],[2,2]].base
     None
     */
    // boolean indexing
    // note that if not assignment, returned copy value not view.
    /*
     a = np.arange(5)
     >>> a[a==1]
     array([1])
     >>> a[a==1].base
     None
     */
    /*
     var a = [0.0, 2.0, 3.0, 1.0]
     var c = [0.0, 0, 0]
     var bb: [UInt] = [1, 1, 3]
     vDSP_vgathrD(&a, &bb, vDSP_Stride(1), &c, vDSP_Stride(1), vDSP_Length(c.count))
     print(c)
     //[0.0, 0.0, 3.0]
     */
    if mfarray.isReal{
        let newdata = MfData(size: indices.size, mftype: mfarray.mftype)
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptrT in
            let _ = mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                srcptr in
                var offsets = (indices.data as! [Int]).map{ UInt(get_positive_index($0, axissize: mfarray.size, axis: 0) * mfarray.strides[0] + 1) }
                wrap_vDSP_gathr(indices.size, srcptr, &offsets, 1, dstptrT, 1, vDSP_func)
            }
        }
        
        let newstructure = MfStructure(shape: indices.shape, strides: indices.strides)
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
    else{
        let newdata = MfData(size: indices.size, mftype: mfarray.mftype, complex: true)
        newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.vDSPComplexType.self){
            dstptrT in
            let _ = mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.vDSPComplexType.self){
                srcptr in
                let srcptrr = srcptr.pointee.realp as! UnsafeMutablePointer<T>
                let srcptri = srcptr.pointee.imagp as! UnsafeMutablePointer<T>
                let dstptrTr = dstptrT.pointee.realp as! UnsafeMutablePointer<T>
                let dstptrTi = dstptrT.pointee.imagp as! UnsafeMutablePointer<T>
                
                var offsets = (indices.data as! [Int]).map{ UInt(get_positive_index($0, axissize: mfarray.size, axis: 0) * mfarray.strides[0] + 1) }
                wrap_vDSP_gathr(indices.size, srcptrr, &offsets, 1, dstptrTr, 1, vDSP_func)
                wrap_vDSP_gathr(indices.size, srcptri, &offsets, 1, dstptrTi, 1, vDSP_func)
            }
        }
        
        let newstructure = MfStructure(shape: indices.shape, strides: indices.strides)
        return MfArray(mfdata: newdata, mfstructure: newstructure)
    }
}

/*
internal typealias vDSP_vlim_func<T: MfStorable> = (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void

internal func lim_by_vDSP<T: MfStorable>(_ mfarray: MfArray, point: T, to: T, _ vDSP_func: vDSP_vlim_func<T>){
    let mfarray = check_contiguous(mfarray)
    var point = point
    var to = to
    
    mfarray.withDataUnsafeMBPtrT(datatype: T.self){
        [unowned mfarray] dataptr in
        vDSP_func(dataptr.baseAddress!, vDSP_Stride(1), &point, &to, dataptr.baseAddress!, vDSP_Stride(1), vDSP_Length(mfarray.storedSize))
    }
}
*/

/// Dot product between multiple dimensional arraies
/// - Parameters:
///   - l_mfarray: A left mfarray
///   - r_mfarray: A right mfarray
///   - vDSP_func: vDSP_dotpr_func
/// - Returns: Dot producted mfarray
internal func dotpr_by_vDSP<T: MfStorable>(_ l_mfarray: MfArray, _ r_mfarray: MfArray, vDSP_func: vDSP_dotpr_func<T>) -> MfArray{
    let l_shape = l_mfarray.shape
    let r_shape = r_mfarray.shape
    assert(l_shape[0] == r_shape[1])
    
    // calculate loop size
    let size = l_shape[0]
    
    // to row major
    let l_mfarray = check_contiguous(l_mfarray, .Row)
    let r_mfarray = r_mfarray.swapaxes(axis1: -1, axis2: -2).to_contiguous(mforder: .Row)
    
    // calculate shape
    var l_rest_shape = Array(l_shape.prefix(l_shape.count - 1))
    var r_rest_shape = Array(r_shape.prefix(r_shape.count - 2) + r_shape.suffix(1))
    var ret_shape = l_rest_shape + r_rest_shape
    
    // calculate size
    let l_rest_size = l_rest_shape.count > 0 ? shape2size(&l_rest_shape) : 1
    let r_rest_size = shape2size(&r_rest_shape)
    let ret_size = shape2size(&ret_shape)
    
    let newdata = MfData(size: ret_size, mftype: l_mfarray.mftype)
    
    newdata.withUnsafeMutableStartPointer(datatype: T.self){
        dstptr in
        l_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
            lptr in
            r_mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                rptr in
                for l_ind in 0..<l_rest_size{
                    for r_ind in 0..<r_rest_size{
                        wrap_vDSP_dotpr(size, lptr + l_ind*size, 1, rptr + r_ind*size, 1, dstptr + (l_ind*r_rest_size + r_ind), vDSP_func)
                    }
                }
            }
        }
    }
    
    let newstructure = MfStructure(shape: ret_shape, mforder: .Row)
    
    return MfArray(mfdata: newdata, mfstructure: newstructure)
}

/// Real FFT.
/// - Parameters:
///   - mfarray: A left mfarray
///   - isForward: Whether to be forward or not.
///   - vDSP_func: vDSP_fft_zrop_func
/// - Returns: FFT array
internal func fft_zr_by_vDSP<T: vDSP_ComplexTypable>(_ mfarray: MfArray, _ number: Int?, _ axis: Int, _ isForward: Bool, vDSP_func: vDSP_fft_zrop_func<T>) -> MfArray{
    precondition(mfarray.isReal, "Must be real in REAL FFT. Use FFT instead")
    
    let mftype = MfType.storedType(mfarray.mftype).to_mftype()
    let axis = get_positive_axis(axis, ndim: mfarray.ndim)
    
    // calculate number to process
    let blocksize_src = mfarray.shape[axis]
    let number = number ?? blocksize_src
    let blocklog2N = Int(log2(Float(number)))
    let process_number = Int(powf(2.0, Float(blocklog2N)))
    
    assert(process_number >= number, "Bug was occurred")
    var src_mfarray: MfArray
    if number < blocksize_src {
        // extract
        src_mfarray = mfarray.moveaxis(src: axis, dst: 0)[0~<number].moveaxis(src: 0, dst: axis)
    }
    else{
        src_mfarray = mfarray
    }
    
    // Whether to pad zero or not for vDSP
    if process_number > number {
        var srcShape = mfarray.shape
        srcShape[axis] = process_number
        src_mfarray = Matft.nums(Double.zero, shape: srcShape)
        /*TODO: Use slice version
        let slices = srcShape.map{MfSlice(start: 0, to: $0, by: 1)}
        src_mfarray[slices] = mfarray*/
        src_mfarray.moveaxis(src: axis, dst: 0)[~<blocksize_src] = mfarray.moveaxis(src: axis, dst: 0)
        // The below code is not needed because the above codes allow to assign the original value using the isView feature in Matft
        //src_mfarray = src_mfarray.moveaxis(src: 0, dst: axis)
    }
    
    // to complex and contiguous
    src_mfarray = check_contiguous(src_mfarray.moveaxis(src: axis, dst: -1), .Row).to_complex()
    
    assert(process_number % 2 == 0, "Bug was occurred")
    let blocksize_dst = process_number/2 + 1
    var retShape = mfarray.shape
    retShape[retShape.count - 1] = blocksize_dst
    
    let newdata = MfData(size: shape2size(&retShape), mftype: mftype, complex: true)
    
    var restShape = Array(retShape.prefix(retShape.count-1))
    let loopnum = shape2size(&restShape)
    
    newdata.withUnsafeMutablevDSPComplexPointer(datatype: T.self){dstptr in
        src_mfarray.withUnsafeMutablevDSPComplexPointer(datatype: T.self){
            srcptr in
            for i in 0..<loopnum{
                var src = srcptr +++ i*blocksize_src
                var dst = dstptr +++ i*blocksize_dst
                wrap_vDSP_fft_zr(blocklog2N, &src, 1, &dst, 1, isForward, vDSP_func)
                // the first element of imaginary part is nyquist component. Therefore, assign it multiplied -1 =(exp(i*pi)) to the last element
                // ref: https://developer.apple.com/library/mac/documentation/Performance/Conceptual/vDSP_Programming_Guide/UsingFourierTransforms/UsingFourierTransforms.html#//apple_ref/doc/uid/TP40005147-CH3-SW1
                (dst.realp + blocksize_dst-1).pointee = -1*dst.imagp.pointee
                dst.imagp.pointee = 0
            }
            
        }
    }
    
    let newstructure = MfStructure(shape: retShape, mforder: .Row)

    let ret = MfArray(mfdata: newdata, mfstructure: newstructure).moveaxis(src: -1, dst: axis)
    
    // rescale because zrop was 2x. 
    return ret / 2
}

/// Convert mfarray into CGImage. Supported color space is Gray (h, w), (h, w, 1)  or RGB (h, w, 4)
/// - Parameters:
///   - src_mfarray: An input mfarray
///   - vDSP_func: vDSP_convert_func
/// - Returns: CGImage
/// ref: https://stackoverflow.com/questions/34677133/how-to-reconstruct-grayscale-image-from-intensity-values
/// OpenCV: https://github.com/opencv/opencv/blob/ed69bcae2d171d9426cd3688a8b0ee14b8a140cd/modules/imgcodecs/src/apple_conversions.mm#L47
internal func mfarray2cgimage_by_vDSP<T: MfStorable>(_ src_mfarray: MfArray, vDSP_func: vDSP_convert_func<T, UInt8>) -> CGImage{
    var (mfarray, height, width, channel) = check_and_convert_image_dim(src_mfarray)

    let colorSpace: CGColorSpace
    let bitmapInfo: CGBitmapInfo
    
    if src_mfarray.mftype == .Float{
        if channel == 1{// gray
            colorSpace = CGColorSpaceCreateDeviceGray()
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue | CGImageByteOrderInfo.order32Little.rawValue | CGBitmapInfo.floatComponents.rawValue)
        }
        else if channel == 4{
            colorSpace = CGColorSpaceCreateDeviceRGB()
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Little.rawValue | CGBitmapInfo.floatComponents.rawValue)
        }
        else{
            preconditionFailure("Unsupported channel number: \(mfarray.shape[2])")
        }
        
        mfarray = check_contiguous(mfarray, .Row)
        return mfarray.withUnsafeMutableStartRawPointer{
            srcptr in
            // NOTE: Force cast to UInt8
            return _rawptr2cgimage(srcptr.assumingMemoryBound(to: UInt8.self), bitmapInfo: bitmapInfo, colorSpace: colorSpace, byteNumber: 4, width: width, height: height, channel: channel)
        }
    }
    else{
        if channel == 1{// gray
            colorSpace = CGColorSpaceCreateDeviceGray()
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
        }
        else if channel == 4{
            colorSpace = CGColorSpaceCreateDeviceRGB()
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
        }
        else{
            preconditionFailure("Unsupported channel number: \(mfarray.shape[2])")
        }
        var shape = mfarray.shape
        var arr = Array<UInt8>(repeating: UInt8.zero, count: src_mfarray.size)
        let dst_strides = shape2strides(&shape, mforder: .Row)
        
        // StoredType to UInt8 (row_contiguous)
        arr.withUnsafeMutableBufferPointer{
            dstptrU in
            mfarray.withUnsafeMutableStartPointer(datatype: T.self){
                [unowned mfarray] srcptrT in
                
                for vDSPPrams in OptOffsetParamsSequence(shape: shape, bigger_strides: dst_strides, smaller_strides: mfarray.strides){
                    
                    wrap_vDSP_convert(vDSPPrams.blocksize, srcptrT + vDSPPrams.s_offset, vDSPPrams.s_stride, dstptrU.baseAddress! + vDSPPrams.b_offset, vDSPPrams.b_stride, vDSP_func)
                }
                
            }
        }
        
        return _rawptr2cgimage(&arr, bitmapInfo: bitmapInfo, colorSpace: colorSpace, byteNumber: 1, width: width, height: height, channel: channel)
    }
}

/// Convert mfarray into CGImage
/// - Parameters:
///   - src_mfarray: An input mfarray
///   - vDSP_func: vDSP_convert_func
/// - Returns: CGImage
/// OpenCV: https://github.com/opencv/opencv/blob/ed69bcae2d171d9426cd3688a8b0ee14b8a140cd/modules/imgcodecs/src/apple_conversions.mm#L47
internal func cgimage2mfarray_by_vDSP<T: MfStorable>(_ cgimage: CGImage, mftype: MfType, vDSP_func: vDSP_convert_func<UInt8, T>) -> MfArray{
    precondition(mftype == .Float || mftype == .UInt8, "mftype must be Float or UInt8, but got \(mftype)")
    
    let width = Int(cgimage.width)
    let height = Int(cgimage.height)
    let byteNumber = Int(cgimage.bitsPerComponent/8)
    let channel = Int(cgimage.bitsPerPixel/cgimage.bitsPerComponent)
    let srcmftype: MfType = byteNumber == 1 ? .UInt8 : .Float
    
    let colorModel: CGColorSpaceModel = cgimage.colorSpace!.model
    let bitmapInfo: CGBitmapInfo
    let colorSpace: CGColorSpace
    
    let size = width*height*channel
    let newdata = MfData(size: size, mftype: srcmftype)
    let newstructure = MfStructure(shape: [height, width, channel], mforder: .Row)
    
    if srcmftype == .Float{
        
        //====== cgimage to Float ======//
        if (colorModel == CGColorSpaceModel.monochrome){
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue | CGImageByteOrderInfo.order32Little.rawValue | CGBitmapInfo.floatComponents.rawValue)
            colorSpace = CGColorSpaceCreateDeviceGray()
        }
        else if (colorModel == CGColorSpaceModel.indexed){
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Little.rawValue | CGBitmapInfo.floatComponents.rawValue)
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        else{
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Little.rawValue | CGBitmapInfo.floatComponents.rawValue)
            colorSpace = cgimage.colorSpace!
        }
        
        // NOTE: Force cast to UInt8 = raw pointer
        newdata.withUnsafeMutableStartPointer(datatype: UInt8.self){
            _cgimage2rawptr($0, cgimage, bitmapInfo: bitmapInfo, colorSpace: colorSpace, byteNumber: byteNumber, width: width, height: height, channel: channel)
        }
    }
    else{
        
        //====== cgimage to UInt8 ======//
        if (colorModel == CGColorSpaceModel.monochrome){
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
            colorSpace = CGColorSpaceCreateDeviceGray()
        }
        else if (colorModel == CGColorSpaceModel.indexed){
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        else{
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
            colorSpace = cgimage.colorSpace!
        }
        
        // tmp UInt8 array
        var arr = Array<UInt8>(repeating: UInt8.zero, count: size)

        _cgimage2rawptr(&arr, cgimage, bitmapInfo: bitmapInfo, colorSpace: colorSpace, byteNumber: byteNumber, width: width, height: height, channel: channel)
        newdata.withUnsafeMutableStartPointer(datatype: T.self){
            dstptr in
            wrap_vDSP_convert(size, &arr, 1, dstptr, 1, vDSP_func)
        }
    }
    
    var ret = MfArray(mfdata: newdata, mfstructure: newstructure).squeeze()
    if srcmftype != mftype{
        if mftype == .Float{
            ret = ui8Xfloat_image(ret)
        }
        else{
            ret = floatXui8_image(ret)
        }
        return ret.astype(mftype)
    }
    else{
        return ret
    }
}


fileprivate func _rawptr2cgimage(_ srcrawptr: UnsafeMutablePointer<UInt8>, bitmapInfo: CGBitmapInfo, colorSpace: CGColorSpace, byteNumber: Int, width: Int, height: Int, channel: Int) -> CGImage{
    let provider = CGDataProvider(data: CFDataCreate(kCFAllocatorDefault, srcrawptr, width*height*channel*byteNumber))
    let cgimage =  CGImage(width: width, height: height, bitsPerComponent: 8*byteNumber, bitsPerPixel: 8*channel*byteNumber, bytesPerRow: width*channel*byteNumber, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)!
    
    return cgimage
}

///
//@inline(__always)
fileprivate func _cgimage2rawptr(_ dstrawptr: UnsafeMutablePointer<UInt8>, _ cgimage: CGImage, bitmapInfo: CGBitmapInfo, colorSpace: CGColorSpace, byteNumber: Int, width: Int, height: Int, channel: Int){
    
    let contextRef = CGContext(data: dstrawptr, width: width, height: height, bitsPerComponent: 8*byteNumber, bytesPerRow: width*channel*byteNumber, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
    contextRef?.draw(cgimage, in: CGRect(x: 0, y: 0, width: width, height: height))
}
