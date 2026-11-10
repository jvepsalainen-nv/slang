//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=Negative probe of the purely syntactic scan-time checks: a leading `0` on a decimal-looking literal raises the legacy-octal warning (W10002).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that literal scanning performs the small set of syntactic
// checks the split allows even though value decoding is deferred:
// `017` is scanned as a legacy octal literal and the scanner warns
// about the `0` prefix. The caret must span the whole literal token
// the scanner recorded, and the warning is pinned to W10002 so a
// renumbering cannot pass silently.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

static const int legacy = 017;
//CHECK:                  ^^^ '0' prefix indicates octal literal
// CHECK: W10002

void main() {}
