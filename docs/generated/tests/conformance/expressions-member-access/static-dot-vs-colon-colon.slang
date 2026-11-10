//META: generated=true
//META: doc_ref=docs/language-reference/expressions-member-access.md#static-member-expressions
//META: purpose=Static member access via `.` and `::` are equivalent per the doc's "These are equivalent: Color.Red and Color::Red."
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green, Blue }

void main()
{
    Color a = Color.Red;
    Color b = Color::Red;
    Color c = Color.Green;
    Color d = Color::Green;
    bool eqRed = (a == b);
    bool eqGreen = (c == d);
    //CHECK: a=0 b=0 c=1 d=1 eqRed=1 eqGreen=1
    printf("a=%d b=%d c=%d d=%d eqRed=%d eqGreen=%d\n",
           int(a), int(b), int(c), int(d),
           eqRed ? 1 : 0, eqGreen ? 1 : 0);
}
