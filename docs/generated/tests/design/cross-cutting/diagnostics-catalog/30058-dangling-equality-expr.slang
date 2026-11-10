//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic W30058 (dangling-equality-expr) - result of '==' not used
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30058
//META: catalog_name=dangling-equality-expr
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An `==` whose result is discarded as a statement fires the warning.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    int a = 1;
    int b = 2;
    a == b;
}

//CHECK: 30058
