//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that an IntegerLiteralExpr with the `u` suffix at uint MAX (0xFFFFFFFFu) carries the unsigned MAX value through evaluation.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `u`-suffixed literal at the top of the unsigned 32-bit range
// keeps its full magnitude. 0xFFFFFFFFu is stored and printed as an unsigned
// value; the CHECK asserts 4294967295, which a signed reinterpretation would
// print as -1.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    uint v = 0xFFFFFFFFu;
    // CHECK: v=4294967295
    printf("v=%u\n", v);
}
