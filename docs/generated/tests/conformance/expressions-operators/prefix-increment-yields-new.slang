//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#prefix-operator-expressions
//META: purpose=Prefix `++x` yields the **new** value per the doc's explicit bullet list "Read → Increment → Write → Yield the new value".
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's bullet list for the built-in prefix `++` operator says
// the expression yields the NEW (post-increment) value. Compared to
// the postfix sibling (which yields the OLD value), this is the
// distinguishing contract. Verify both the yielded value and the
// updated variable.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 10;
    int yielded = ++x;
    //CHECK: yielded=11 x=11
    printf("yielded=%d x=%d\n", yielded, x);
}
