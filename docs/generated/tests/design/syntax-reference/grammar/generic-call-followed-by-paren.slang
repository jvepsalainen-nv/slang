//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#-disambiguation
//META: purpose=`<` is treated as a generic-argument list when followed by `>` and a "generic-follower" token like `(`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive side of the `<` disambiguation: in
// `max<int>(1, 2)`, the parser sees `<int>` followed by `(`, which is
// in the generic-followers set, so `<` opens a generic-argument list.

//TEST:INTERPRET(filecheck=CHECK):

T myMax<T : __BuiltinArithmeticType>(T a, T b) { return a > b ? a : b; }

void main()
{
    int r = myMax<int>(3, 7);
    // CHECK: r=7
    printf("r=%d\n", r);
}
