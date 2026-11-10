//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#layout-family
//META: purpose=A cbuffer lowers to a parameterGroupTypeLayout whose first three operands are the container var layout, the element var layout, and the offset element type layout.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the three fixed operands of a parameter-group layout. A `cbuffer`
// is the canonical surface. The CHECKs capture operands 0-2 of the emitted
// `parameterGroupTypeLayout` and then follow each id to its definition: the
// element var layout must be a `varLayout` whose own type-layout operand is
// the captured offset-element type layout, and the container operand must be
// a `varLayout` too -- which is only consistent with the documented order.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

cbuffer CB
{
    float4 color;
}

uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = color.x;
}

// CHECK: = parameterGroupTypeLayout(%[[CONTAINER:[0-9]+]], %[[ELEM:[0-9]+]], %[[OFFELEM:[0-9]+]], %{{[0-9]+}})
// CHECK: %[[ELEM]]{{.*}}= varLayout(%[[OFFELEM]])
// CHECK: %[[OFFELEM]]{{.*}}= structTypeLayout(
// CHECK: %[[CONTAINER]]{{.*}}= varLayout(
