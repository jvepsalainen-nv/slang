//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30099 (size-of-argument-is-invalid) - invalid sizeof argument
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30099
//META: catalog_name=size-of-argument-is-invalid
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Applying sizeof to a function reference is invalid.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void foo() {}

void main()
{
    int s = sizeof(foo);
}

//CHECK: 30099
