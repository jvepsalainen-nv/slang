//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E41400 (static-assertion-failure) - static assertion failed
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=41400
//META: catalog_name=static-assertion-failure
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A static_assert(false, "msg") with a literal-string message
// triggers the static-assertion-with-message failure diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute

[numthreads(1,1,1)]
void main() {
    static_assert(false, "math is broken");
}

//CHECK: E41400
