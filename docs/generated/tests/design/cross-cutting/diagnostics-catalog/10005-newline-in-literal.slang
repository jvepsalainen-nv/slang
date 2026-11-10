//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10005 (newline-in-literal) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10005
//META: catalog_name=newlineInLiteral
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10005.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
int x = "hello
world";
void main() { x; }

//CHECK: E10005
