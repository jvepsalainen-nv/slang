//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30820 (base-struct-must-be-listed-first) -- a struct type may only inherit from one other struct type, and that type must appear first in the list of bases
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30820
//META: catalog_name=base-struct-must-be-listed-first
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface I {}
struct A {}
struct B {}
struct C : I, A, B {}


//CHECK: E30820
