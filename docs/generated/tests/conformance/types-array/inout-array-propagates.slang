//META: generated=true
//META: doc_ref=docs/language-reference/types-array.md#declaration-syntax
//META: purpose=Companion to the pass-by-value test: when the parameter is declared `inout`, mutations DO propagate back to the caller.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pass-by-value is the default. To explicitly propagate
// mutations, the parameter must be declared `inout`. This test
// is the positive control to the `pass-by-value-not-decay`
// negative test in this same bundle.

//TEST:INTERPRET(filecheck=CHECK):

void mutateInOut(inout int x[3])
{
    x[0] = 99;
    x[1] = 88;
    x[2] = 77;
}

void main()
{
    int caller[3] = { 1, 2, 3 };
    mutateInOut(caller);
    //CHECK: caller=99 88 77
    printf("caller=%d %d %d\n", caller[0], caller[1], caller[2]);
}
