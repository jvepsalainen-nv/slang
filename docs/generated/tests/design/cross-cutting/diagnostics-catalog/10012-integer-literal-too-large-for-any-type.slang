//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10012 (integer-literal-too-large-for-any-type) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10012
//META: catalog_name=integerLiteralTooLargeForAnyType
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10012.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = 99999999999999999999999999;
void main() { x; }

//CHECK: E10012
