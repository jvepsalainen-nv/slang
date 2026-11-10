//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E32006 (enum-case-implicit-tag-value-overflow) - implicit enum case value overflows underlying tag type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=32006
//META: catalog_name=enum-case-implicit-tag-value-overflow
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Setting an explicit case to the max of int and letting the next
// implicit case overflow triggers E32006.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

enum E
{
    A = 2147483647,
    B,
}

//CHECK: E32006