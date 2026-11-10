//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#error-recovery
//META: purpose=While the parser is recovering, no further unexpected-token diagnostic is reported, so a run of three bad tokens yields exactly one syntax error.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the cascade-suppression half of error recovery. Three consecutive
// unrecognised punctuators appear in statement position; each on its own would
// be an unexpected token, so a parser without the recovering flag would report
// three errors. The directive runs in exhaustive mode, meaning any diagnostic
// the CHECK annotations do not consume fails the test — so a single annotated
// error at the first `@` is what proves the following two were suppressed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int a = 1;
    @ @ @ ;
/*CHECK:
    ^ error E20002
    ^ syntax error.
*/
    int b = a;
}
