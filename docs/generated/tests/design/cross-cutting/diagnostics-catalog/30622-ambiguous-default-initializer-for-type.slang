//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30622 (ambiguous-default-initializer-for-type) -- more than one default initializer was found for type '~type:Type'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30622
//META: catalog_name=ambiguous-default-initializer-for-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S {
    __init() {}
    __init() {}
}
[shader("compute")][numthreads(1,1,1)]
void main() {
    S s;
}


//CHECK: E30622
