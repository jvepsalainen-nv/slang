//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`WhereTerm` accepts the oriented pack-count constraint `'countof' '(' Expr ')' '==' Expr`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `countof(Pack) == N` where-term in its documented
// orientation (countof on the left). A generic constrained to a
// two-type pack specializes with exactly two explicit arguments,
// proving the constraint parsed and was checked.

//TEST:INTERPRET(filecheck=CHECK):

int pairArity<each T>() where countof(T) == 2
{
    return 22;
}

void main()
{
    // CHECK: r=22
    printf("r=%d\n", pairArity<int, float>());
}
