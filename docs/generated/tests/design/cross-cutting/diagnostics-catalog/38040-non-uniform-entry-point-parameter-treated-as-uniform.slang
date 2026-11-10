//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38040 (non-uniform-entry-point-parameter-treated-as-uniform) - entry point parameter treated as uniform
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38040
//META: catalog_name=non-uniform-entry-point-parameter-treated-as-uniform
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A compute entry point parameter with no system-value semantic
// and no `uniform` modifier is auto-converted to uniform with a
// warning.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main

[numthreads(1,1,1)]
void main(int p)
{
}

//CHECK: E38040