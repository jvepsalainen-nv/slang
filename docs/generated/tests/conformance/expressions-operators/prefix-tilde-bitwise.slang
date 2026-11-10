//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#prefix-operator-expressions
//META: purpose=Prefix `~` is bitwise Boolean negation per the operator table; `~0u` is `UINT_MAX` (all bits set).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

uint invert(uint x) { return ~x; }

void main()
{
    uint a = invert(0u);
    uint b = invert(0xFFFFFFFFu);
    //CHECK: a=4294967295 b=0
    printf("a=%u b=%u\n", a, b);
}
