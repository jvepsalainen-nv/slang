//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#macro-expansion
//META: purpose=Negative probe of function-style macros: invoking a 2-parameter macro with only 1 argument is rejected with the documented arg-count diagnostic.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that argument replay is index-based against the macro's
// parameter list, so an invocation that supplies fewer arguments than
// there are parameters has no token range to replay for the missing
// index and is rejected. The under-supply boundary (2 parameters,
// 1 argument) is pinned to E15501 with the expected/got counts in the
// message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#define BIN(a, b) ((a) + (b))

static const int q = BIN(1);
//CHECK:                ^ wrong macro argument count
//CHECK:                ^ wrong number of arguments to macro (expected 2, got 1)
// CHECK: E15501

void main() {}
