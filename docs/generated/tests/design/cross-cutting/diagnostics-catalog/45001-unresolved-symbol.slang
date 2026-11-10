//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E45001 (unresolved-symbol) - unresolved external symbol
//META: intent=negative
//META: pipeline_stage=link
//META: catalog_code=45001
//META: catalog_name=unresolved-symbol
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An `extern` function declared but never defined produces an
// unresolved-external-symbol error at link time.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute

extern void doSomething();

[numthreads(1,1,1)]
void main() {
    doSomething();
}

//CHECK: E45001
