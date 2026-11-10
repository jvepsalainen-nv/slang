//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Negative: assigning an int[3] to an int[4] is rejected because Array types with different elementCount are distinct.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// assigning an int[3] to an int[4] is rejected because Array types
// with different elementCount are distinct. Two `Array` types with
// different `elementCount` are distinct IR types, so a cross-extent
// assignment fires a type-mismatch diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int a[3] = { 1, 2, 3 };
    int b[4] = a;
//CHECK:       ^ type mismatch in expression
//CHECK:       ^ expected an expression of type 'int[4]', got 'int[3]'
// CHECK: E30019
    buf[0] = b[0];
}
