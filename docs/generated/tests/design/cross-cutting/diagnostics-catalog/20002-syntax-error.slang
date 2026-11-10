//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E20002 (syntax-error) - syntax error
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=20002
//META: catalog_name=syntax-error
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An initializer must contain an expression. Omitting it leaves the parser with
// no expression to build, and the CHECK pins the generic syntax-error code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = ; }

//CHECK: E20002
