//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15900 (user-defined-error) - preprocessor error
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15900
//META: catalog_name=user-defined-error
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#error` turns its message into a compiler error at the point it is reached.
// Placing it unconditionally at file scope fires it, and the CHECK pins the
// user-defined-error code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#error deliberate user-defined preprocessor error
void main() {}

//CHECK: E15900
