//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#integer-literals
//META: purpose=Underscores embedded in an integer-literal digit sequence are ignored per the doc: "The digits of an integer literal may also include underscore (`_`) characters, which are ignored and have no semantic impact."
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 1_000_000;
    int b = 1000000;
    int c = 0x_FF_FF;
    bool eq = (a == b) && (c == 0xFFFF);
    //CHECK: a=1000000 b=1000000 c=65535 eq=1
    printf("a=%d b=%d c=%d eq=%d\n", a, b, c, eq ? 1 : 0);
}
