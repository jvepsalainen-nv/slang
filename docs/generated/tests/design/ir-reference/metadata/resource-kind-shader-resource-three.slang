//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#size-and-offset
//META: purpose=A read-only texture parameter uses LayoutResourceKind 3, shader resource, in operand 0 of its size and offset attributes.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies one row of the resource-kind enumeration that operand 0 of `size`
// and `offset` encodes. The numbers print bare, so a dump is only readable if
// the construct-to-number mapping is pinned per row. The CHECKs start at the
// named `gTex` field key and follow its var layout to both attributes, so a
// kind that moved off operand 0 would fail rather than silently re-read.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -entry main -stage compute

Texture2D<float4> gTex;
RWStructuredBuffer<float> gOut;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    gOut[0] = gTex.Load(int3(int(tid.x), 0, 0)).y;
}

// CHECK: = structFieldLayout(%gTex, %[[VL:[0-9]+]])
// CHECK: {{^}}let %[[VL]]{{[^0-9]}}{{.*}}= varLayout(%[[TL:[0-9]+]], %[[OFF:[0-9]+]])
// CHECK: {{^}}let %[[OFF]]{{[^0-9]}}{{.*}}= offset(3 : Int, 0 : Int)
// CHECK: {{^}}let %[[TL]]{{[^0-9]}}{{.*}}= typeLayout(%[[SZ:[0-9]+]])
// CHECK: {{^}}let %[[SZ]]{{[^0-9]}}{{.*}}= size(3 : Int, 1 : Int)
