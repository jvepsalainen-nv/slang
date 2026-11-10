//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10003 (invalid-digit-for-base) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10003
//META: catalog_name=invalidDigitForBase
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10003.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = 0b2;
void main() { x; }

//CHECK: E10003
