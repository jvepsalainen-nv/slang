//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that an empty StringLiteralExpr `""` lowers and appears as an empty string literal in emitted C++ output.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for StringLiteralExpr: an empty string. The
// emitted C++ printf call must contain `""` verbatim.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("");
    // CHECK: printf("")
}
