; REQUIRES: asserts
; RUN: opt -module-summary %s -o %t1.bc
; RUN: opt -module-summary -o %t2.bc %S/Inputs/not-prevailing.ll
; RUN: not --crash llvm-lto2 run -o %t3.bc %t1.bc %t2.bc -r %t1.bc,bar,px \
; RUN:     -r %t1.bc,foo,x -r %t2.bc,foo,x -save-temps 2>&1 | FileCheck %s

; CHECK: "Symbol with interposable and available_externally linkages"

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define available_externally i32 @foo() {
  ret i32 1
}

define i32 @bar() {
  %1 = call i32 @foo()
  ret i32 %1
}
