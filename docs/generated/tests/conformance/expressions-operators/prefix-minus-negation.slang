//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#prefix-operator-expressions
//META: purpose=Prefix `-` is arithmetic negation per the operator table; `-x` equals `0 - x`.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

int negate(int x) { return -x; }

void main()
{
    int a = negate(7);
    int b = negate(-3);
    int c = negate(0);
    //CHECK: a=-7 b=3 c=0
    printf("a=%d b=%d c=%d\n", a, b, c);
}
