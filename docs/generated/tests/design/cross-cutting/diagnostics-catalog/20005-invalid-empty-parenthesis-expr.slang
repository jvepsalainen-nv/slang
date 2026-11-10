//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E20005 (invalid-empty-parenthesis-expr) - invalid empty parentheses expression
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=20005
//META: catalog_name=invalid-empty-parenthesis-expr
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `()` is not an expression: parentheses must wrap something. The CHECK pins
// the dedicated empty-parentheses error rather than a generic syntax error,
// showing the parser recognises this shape specifically.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = (); }

//CHECK: E20005
