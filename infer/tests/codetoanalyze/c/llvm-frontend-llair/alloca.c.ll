; Copyright (c) Facebook, Inc. and its affiliates.
;
; This source code is licensed under the MIT license found in the
; LICENSE file in the root directory of this source tree.
;
; The size of a stack allocation. With opaque pointers (LLVM >= 15) the
; allocated type is a property of the alloca instruction, not of its pointer
; type: an alloca of n elements of type T must be translated to
; [alloc [n x sizeof(T)]].

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.S = type { i32, i32, i32 }

declare void @use(ptr)

; char b[16]: one element of 16 bytes.
define void @alloca_array() {
  %b = alloca [16 x i8], align 1
  call void @use(ptr %b)
  ret void
}

; Three 12-byte structs.
define void @alloca_struct_count() {
  %s = alloca %struct.S, i64 3, align 4
  call void @use(ptr %s)
  ret void
}

; char c: one byte.
define void @alloca_char() {
  %c = alloca i8, align 1
  call void @use(ptr %c)
  ret void
}

; A variable-length array of n doubles.
define void @alloca_vla(i64 %n) {
  %v = alloca double, i64 %n, align 8
  call void @use(ptr %v)
  ret void
}
