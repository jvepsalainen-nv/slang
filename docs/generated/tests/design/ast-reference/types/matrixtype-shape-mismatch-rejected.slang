//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=Two MatrixExpressionTypes with different row/column counts are distinct; assigning a float2x2 to a float3x3 is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe of the row and column operands: float2x2 and float3x3
// differ in both counts and there is no implicit conversion between
// them. CHECK pins the type-mismatch pair, whose rendered types spell
// out both shapes.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    float2x2 a = float2x2(1, 2, 3, 4);
    float3x3 b = a;
//CHECK:         ^ type mismatch in expression
//CHECK:         ^ expected an expression of type 'matrix<float,3,3>', got 'matrix<float,2,2>'
}
