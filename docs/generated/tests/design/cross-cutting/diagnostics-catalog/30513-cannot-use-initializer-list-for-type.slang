//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30513 (cannot-use-initializer-list-for-type) -- cannot use initializer list for type '~type:Type'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30513
//META: catalog_name=cannot-use-initializer-list-for-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[shader("compute")][numthreads(1,1,1)]
void main() {
    Texture2D t = {1};
}


//CHECK: E30513
