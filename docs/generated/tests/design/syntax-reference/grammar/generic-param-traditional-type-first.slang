//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`GenericParam` accepts the traditional type-first value form `Type IDENT`, so `<int N>` declares a value parameter.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the type-first arm of GenericParam. The doc says an identifier
// followed by `:`, `,`, `>` or `=` is a *type* parameter and anything else is
// parsed as a type-first *value* parameter, so `<int N>` must bind a value.
// Using N as a multiplier and printing 42 proves the value reading was taken.

//TEST:INTERPRET(filecheck=CHECK):

int scaleBy<int N>(int x)
{
    return x * N;
}

void main()
{
    // CHECK: r=42
    printf("r=%d\n", scaleBy<7>(6));
}
