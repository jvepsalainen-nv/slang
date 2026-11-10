//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#size-and-offset
//META: purpose=A read-write structured buffer uses LayoutResourceKind 4, unordered access, in operand 0 of its size and offset attributes.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies one row of the resource-kind enumeration that operand 0 of `size`
// and `offset` encodes. This row is the one that separates a writable
// resource from the read-only row next to it, so the test pins 4 on both the
// offset attached to the var layout and the size attached to the buffer's own
// type layout, walking to each from the named `gAccum` field key.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -entry main -stage compute

RWStructuredBuffer<float> gAccum;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    gAccum[tid.x] = float(tid.y);
}

// CHECK: = structFieldLayout(%gAccum, %[[VL:[0-9]+]])
// CHECK: {{^}}let %[[VL]]{{[^0-9]}}{{.*}}= varLayout(%[[TL:[0-9]+]], %[[OFF:[0-9]+]])
// CHECK: {{^}}let %[[OFF]]{{[^0-9]}}{{.*}}= offset(4 : Int, 0 : Int)
// CHECK: {{^}}let %[[TL]]{{[^0-9]}}{{.*}}= structuredBufferTypeLayout(%{{[0-9]+}}, %[[SZ:[0-9]+]])
// CHECK: {{^}}let %[[SZ]]{{[^0-9]}}{{.*}}= size(4 : Int, 1 : Int)
