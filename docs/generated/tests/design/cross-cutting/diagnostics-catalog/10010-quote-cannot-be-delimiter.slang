//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10010 (quote-cannot-be-delimiter) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10010
//META: catalog_name=quoteCannotBeDelimiter
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10010.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int x = R""(hi)"";
void main() { x; }

//CHECK: E10010
