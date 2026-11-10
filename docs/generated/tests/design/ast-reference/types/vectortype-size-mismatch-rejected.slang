//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=Two VectorExpressionTypes with different counts are distinct types; assigning a float2 to a float3 without a conversion is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe of the count operand: float2 and float3 differ only in
// their element count, and no implicit widening exists between them, so
// the assignment must be rejected. CHECK pins the type-mismatch pair,
// whose rendered types name both counts.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    float2 a = float2(1.0, 2.0);
    float3 b = a;
//CHECK:       ^ type mismatch in expression
//CHECK:       ^ expected an expression of type 'vector<float,3>', got 'vector<float,2>'
}
