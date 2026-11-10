//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30071 (var-cannot-be-unsized) - cannot instantiate unsized type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30071
//META: catalog_name=var-cannot-be-unsized
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A local variable of an unsized array type is rejected.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    int unsized[];
}

//CHECK: 30071
