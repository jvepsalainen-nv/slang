//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#literal-forms-vs-token-kinds
//META: purpose=`true` and `false` are recognized as `Literal` atoms (BoolLiteralExpr) despite lexing as identifiers.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the identifier-spelled bool literals: `true` and `false`
// participate directly in a boolean expression whose value drives the
// printed result, so both spellings must have parsed as literal atoms.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    let t = true;
    let f = false;
    int r = (t && !f) ? 1 : 0;
    // CHECK: r=1
    printf("r=%d\n", r);
}
