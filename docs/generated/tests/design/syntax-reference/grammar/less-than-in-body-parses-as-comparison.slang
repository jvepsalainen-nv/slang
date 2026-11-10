//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#-disambiguation
//META: purpose=`<` in a body context where the preceding expression does not resolve to a generic parses as the comparison operator.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative side of the `<` disambiguation: in
// `a < b`, both operands are plain int variables, so the parser falls
// back to treating `<` as a less-than comparison.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 3, b = 5;
    bool r = a < b;
    // CHECK: r=1
    printf("r=%d\n", int(r));
}
