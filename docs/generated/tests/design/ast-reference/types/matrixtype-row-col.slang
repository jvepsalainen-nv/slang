//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=A MatrixExpressionType carries an element type, a row count and a column count; a float2x3 value's six elements are reachable by [row][col] indexing.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the (element-type, rows, cols) shape of the matrix
// arithmetic leaf: a float2x3 has 2*3 independently addressable slots.
// All six are printed in row-major order; CHECK asserts each index pair
// reaches its own element, which pins both counts.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float2x3 m = float2x3(1, 2, 3, 4, 5, 6);
    // CHECK: m=1,2,3,4,5,6
    printf("m=%d,%d,%d,%d,%d,%d\n",
        int(m[0][0]), int(m[0][1]), int(m[0][2]),
        int(m[1][0]), int(m[1][1]), int(m[1][2]));
}
