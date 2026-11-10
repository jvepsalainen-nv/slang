//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#types
//META: purpose=In HLSL source `signed` is recognized only to diagnose it (E20021) and `unsigned short` is diagnosed as E20022.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the HLSL-only rejection of `signed` and traditional integer
// names; CHECK-DAG asserts both codes appear.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f()
{
    signed int a = 1;
    unsigned short b = 1;
}

// CHECK-DAG: E20021
// CHECK-DAG: E20022
