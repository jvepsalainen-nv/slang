//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10001 (illegal-character-literal) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10001
//META: catalog_name=illegalCharacterLiteral
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10001.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = '';
void main() { x; }

//CHECK: E10001
