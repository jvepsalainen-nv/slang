//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E41018 (returning-with-uninitialized-out) - returning without initializing out parameter
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: catalog_code=41018
//META: catalog_name=returning-with-uninitialized-out
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A function with an `out` parameter that returns without writing to
// that parameter triggers the returning-with-uninitialized warning.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute

void f(out int x) { return; }

[numthreads(1,1,1)]
void main() {
    int a;
    f(a);
}

//CHECK: E41018
