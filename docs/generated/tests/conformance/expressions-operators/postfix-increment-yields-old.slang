//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#postfix-operator-expressions
//META: purpose=Postfix `x++` yields the **old** value per the doc's bullet list "Read → Increment → Write → Yield the old value".
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's bullet list for the built-in postfix `++` operator says
// the expression yields the OLD (pre-increment) value. The variable
// is still updated (incremented), but the expression's value is the
// pre-increment one. This is the canonical distinction from prefix.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 10;
    int yielded = x++;
    //CHECK: yielded=10 x=11
    printf("yielded=%d x=%d\n", yielded, x);
}
