//META: generated=true
//META: doc_ref=source/compiler-core/slang-lexer-diagnostic-defs.h
//META: purpose=Fires diagnostic E10004 (end-of-file-in-literal) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=10004
//META: catalog_name=endOfFileInLiteral
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E10004.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
//CHECK: E10004
int x = "unterminated