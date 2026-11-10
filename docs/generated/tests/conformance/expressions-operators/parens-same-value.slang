//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#parenthesized-expression
//META: purpose=A parenthesized expression evaluates to the same value as the wrapped expression — `(e)` == `e`.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

int compute(int x, int y) { return x + y; }

void main()
{
    int bare = compute(3, 4);
    int wrapped = (compute(3, 4));
    int doubled = ((compute(3, 4)));
    //CHECK: bare=7 wrapped=7 doubled=7
    printf("bare=%d wrapped=%d doubled=%d\n", bare, wrapped, doubled);
}
