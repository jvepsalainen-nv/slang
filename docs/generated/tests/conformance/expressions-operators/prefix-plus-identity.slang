//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#prefix-operator-expressions
//META: purpose=Prefix `+` is identity per the operator table — `+x` yields the same value as `x`.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

int passthrough(int x) { return +x; }

void main()
{
    int a = passthrough(42);
    int b = passthrough(-17);
    int c = passthrough(0);
    //CHECK: a=42 b=-17 c=0
    printf("a=%d b=%d c=%d\n", a, b, c);
}
