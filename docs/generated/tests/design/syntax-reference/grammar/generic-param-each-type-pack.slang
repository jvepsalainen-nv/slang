//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`GenericParam` accepts the type-pack form `'each' IDENT (':' Type)?` (GenericTypePackParamDecl).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `'each' IDENT` arm of GenericParam. The doc distinguishes it
// from `let each` by two-token lookahead: `each T` introduces a *type* pack.
// Three arguments of three different types are passed and the body reports
// `countof(T)`; printing 3 proves one type-pack parameter absorbed them all.

//TEST:INTERPRET(filecheck=CHECK):

int countArgs<each T>(expand each T args)
{
    return countof(T);
}

void main()
{
    // CHECK: r=3
    printf("r=%d\n", countArgs(1, 2.0f, true));
}
