//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30059 (discarded-no-discard-result) - result of '[NoDiscard]' function is discarded
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30059
//META: catalog_name=discarded-no-discard-result
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[NoDiscard]` marks a result the caller must consume. Calling the function as
// a bare expression statement discards it, and the CHECK pins the
// discarded-result error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
[NoDiscard] int f() { return 1; }
void main() { f(); }

//CHECK: E30059
