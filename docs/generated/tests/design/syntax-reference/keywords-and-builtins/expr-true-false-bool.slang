//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#expression-keywords
//META: purpose=`true` and `false` are expression keywords producing boolean-typed values; they select different branches of a conditional.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Assign `true` and `false` to `bool` locals and use them as the
// conditional in a ternary. The two arms emit distinct values so a
// keyword-stripping bug would not be silently masked.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool t = true;
    bool f = false;
    int ti = t ? 7 : 9;
    int fi = f ? 7 : 9;
    // CHECK: t=7 f=9
    printf("t=%d f=%d\n", ti, fi);
}
