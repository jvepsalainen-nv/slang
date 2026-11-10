//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10002 (octal-literal) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10002
//META: catalog_name=octalLiteral
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10002.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = 0123;
void main() { x; }

//CHECK: E10002
