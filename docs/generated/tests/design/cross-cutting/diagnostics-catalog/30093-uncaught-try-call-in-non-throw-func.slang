//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30093 (uncaught-try-call-in-non-throw-func) - uncaught 'try' in non-throwing function
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30093
//META: catalog_name=uncaught-try-call-in-non-throw-func
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `try` call may propagate an error, so the enclosing function must itself be
// declared `throws`. Calling from a non-throwing `main` leaves the error
// uncaught, and the CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
int g() throws int { throw 1; }
void main() { int x = try g(); }

//CHECK: E30093
