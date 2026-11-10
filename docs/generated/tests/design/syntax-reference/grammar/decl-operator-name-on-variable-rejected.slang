//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=An `'operator' OperatorName` declarator on a non-function is diagnosed as `OperatorNameOnNonFunction` (E20020).
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the restriction that goes with the previous claim: the declarator
// grammar cannot reject an operator name while reading it, so the rejection
// happens in the single choke point every C-style declarator passes through.
// `int operator+ = 10;` is a variable declarator, which is not the branch that
// grants `allowOperatorName`, so the diagnostic must fire on the operator
// token itself rather than on the initializer.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int operator+ = 10;
//CHECK:    ^ error E20020
//CHECK:    ^ an operator name can only be used to declare an operator function

void main()
{
}
