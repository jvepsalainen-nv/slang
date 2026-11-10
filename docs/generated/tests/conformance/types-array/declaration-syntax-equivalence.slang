//META: generated=true
//META: doc_ref=docs/language-reference/types-array.md#declaration-syntax
//META: purpose=All three array-declaration forms (`var x : int[3]`, `int[3] x`, `int x[3]`) declare the same type and accept the same initializer; values read back identically.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var a : int[3] = { 1, 2, 3 };
    int[3] b = { 1, 2, 3 };
    int c[3] = { 1, 2, 3 };
    bool eq = (a[0] == b[0]) && (b[0] == c[0])
           && (a[1] == b[1]) && (b[1] == c[1])
           && (a[2] == b[2]) && (b[2] == c[2]);
    //CHECK: a=1,2,3 b=1,2,3 c=1,2,3 eq=1
    printf("a=%d,%d,%d b=%d,%d,%d c=%d,%d,%d eq=%d\n",
           a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2],
           eq ? 1 : 0);
}
