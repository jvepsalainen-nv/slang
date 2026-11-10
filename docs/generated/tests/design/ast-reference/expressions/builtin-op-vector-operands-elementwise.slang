//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#builtinoperatorexpr
//META: purpose=The builtin-operator fast path covers vector operands: `+` and `*` on int3 values produce elementwise results.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that builtin binary operators accept vector operands, one of
// the operand shapes the checker's fast path recognizes. Two int3 values
// are added and multiplied; CHECK asserts every component so a
// mis-resolved operation kind or a scalar-only path would be caught.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int3 a = int3(1, 2, 3);
    int3 b = int3(10, 20, 30);
    int3 s = a + b;
    int3 p = a * b;
    // CHECK: s=11,22,33
    printf("s=%d,%d,%d\n", s.x, s.y, s.z);
    // CHECK: p=10,40,90
    printf("p=%d,%d,%d\n", p.x, p.y, p.z);
}
