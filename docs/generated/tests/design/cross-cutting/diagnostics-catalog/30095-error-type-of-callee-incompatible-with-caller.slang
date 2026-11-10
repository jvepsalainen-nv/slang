//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30095 (error-type-of-callee-incompatible-with-caller) - incompatible error types
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30095
//META: catalog_name=error-type-of-callee-incompatible-with-caller
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Callee's error type doesn't match caller's declared error type.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct ErrA {}
struct ErrB {}

int inner() throws ErrA { throw ErrA(); }

int outer() throws ErrB
{
    int v = try inner();
    return v;
}

void main() {}

//CHECK: 30095
