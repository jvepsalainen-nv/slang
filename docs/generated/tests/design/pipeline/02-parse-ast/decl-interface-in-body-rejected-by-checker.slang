//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=An `interface` written inside a function body is rejected by the checker nesting rule with E31400, not by the parser.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second, independent nesting validation: the statement parser
// keeps an aggregate type, but the checker's child/parent table does not admit
// an `interface` inside a function, so E31400 is reported (the parser-side
// E30102 is not). CHECK pins the code and the wording.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int main()
{
    interface I { int f(); }
//CHECK:      ^ error E31400
//CHECK:      ^ interface declaration is not allowed inside function.
    return 0;
}
