//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`GenericParam` accepts the value-parameter form `'let' IDENT (':' Type)?` (GenericValueParamDecl).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `'let' IDENT ':' Type` arm of GenericParam, which the doc
// distinguishes from the type-parameter arm. The parameter is used as a
// multiplier in the body, so the printed 42 is only reachable if `N` was
// bound to the *value* 7 rather than to a type named 7.

//TEST:INTERPRET(filecheck=CHECK):

int scaleBy<let N : int>(int x)
{
    return x * N;
}

void main()
{
    // CHECK: r=42
    printf("r=%d\n", scaleBy<7>(6));
}
