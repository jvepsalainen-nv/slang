//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31219 (push-or-specialization-constant-cannot-be-static) -- push/specialization constant storage class error
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31219
//META: catalog_name=push-or-specialization-constant-cannot-be-static
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[SpecializationConstant] static const int x = 5;
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E31219
