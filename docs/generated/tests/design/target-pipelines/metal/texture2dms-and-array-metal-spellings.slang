//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#resource-type-spellings
//META: purpose=A multisampled texture takes the `_ms` stem suffix and a multisampled array takes `_ms_array` in that order, both emitted with `access::read`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the suffix-composition rule for Metal texture spellings, which is
// the one row of the resource table whose emitted name is assembled rather
// than looked up. Declaring both a multisampled texture and a multisampled
// array in one kernel makes the ordering observable: the array suffix has to
// follow the multisample suffix, so a test that only checked for the two
// substrings separately would not distinguish the two orders.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

Texture2DMS<float4> ms;
Texture2DMSArray<float4> msArray;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = ms.Load(int2(tid.xy), 0) + msArray.Load(int3(tid), 0);
}

// CHECK-DAG: texture2d_ms<float, access::read> ms_
// CHECK-DAG: texture2d_ms_array<float, access::read> msArray_
