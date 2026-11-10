//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#other-declaration-parsing-details
//META: purpose=A later declarator of a multi-declarator declaration sees the earlier one, as in `int j = 5, k = j < 7 ? 1 : 0;`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the declaration group completes each declarator as it joins the
// group. `k`'s initializer names `j` from the same declaration, and also has
// the `j <` token shape that the generic-application speculation must reject;
// k==1 is reachable only if `j` was already bound and `<` read as comparison.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int j = 5, k = j < 7 ? 1 : 0;
    //CHECK: k=1
    printf("k=%d\n", k);
}
