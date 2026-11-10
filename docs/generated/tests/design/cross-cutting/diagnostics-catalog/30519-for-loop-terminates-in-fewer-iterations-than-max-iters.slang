//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30519 (for-loop-terminates-in-fewer-iterations-than-max-iters) -- MaxIters exceeds actual iterations
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30519
//META: catalog_name=for-loop-terminates-in-fewer-iterations-than-max-iters
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[shader("compute")][numthreads(1,1,1)]
void main() {
    [MaxIters(100)]
    for (int i = 0; i < 5; ++i) {}
}


//CHECK: E30519
