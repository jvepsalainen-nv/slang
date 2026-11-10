//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#postfix-operator-expressions
//META: purpose=Prefix `--x` yields the new value; postfix `x--` yields the old value. Same yield-old-vs-new contract as the increment pair.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Mirror of the increment yield-old-vs-new contract for `--`.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 10;
    int preYield = --a;

    int b = 10;
    int postYield = b--;

    //CHECK: preYield=9 a=9 postYield=10 b=9
    printf("preYield=%d a=%d postYield=%d b=%d\n", preYield, a, postYield, b);
}
