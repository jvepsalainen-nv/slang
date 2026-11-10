//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10000 (illegal-character-hex) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10000
//META: catalog_name=illegalCharacterHex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10000.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = 0;
void main() { x; }

//CHECK: E10000
