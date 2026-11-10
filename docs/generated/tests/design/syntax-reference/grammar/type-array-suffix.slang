//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#types
//META: purpose=`CoreType` accepts the array form `Type '[' Expr ']'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the array-type spelling `int[4]` as a function-parameter
// type. We sum the elements to prove the array is the right size.

//TEST:INTERPRET(filecheck=CHECK):

int sumOf(int xs[4])
{
    return xs[0] + xs[1] + xs[2] + xs[3];
}

void main()
{
    int xs[4] = { 1, 2, 3, 4 };
    // CHECK: r=10
    printf("r=%d\n", sumOf(xs));
}
