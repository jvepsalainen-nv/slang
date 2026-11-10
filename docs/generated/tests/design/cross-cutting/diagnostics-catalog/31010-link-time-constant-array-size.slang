//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31010 (link-time-constant-array-size) -- Link-time constant sized arrays are a work in progress feature, some aspects of the reflection API may not work
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31010
//META: catalog_name=link-time-constant-array-size
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

extern static const int N;
struct S { int arr[N]; }
ParameterBlock<S> b;
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E31010
