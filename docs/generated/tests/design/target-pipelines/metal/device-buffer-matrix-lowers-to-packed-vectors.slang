//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#metals-three-lowerbufferelementtypetostoragetype-invocations
//META: purpose=The Phase-C `Metal` policy stores a `float3x3` device-buffer field as an array of packed vectors, emitted as MSL `packed_float3`.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Metal buffer-element policy realizes Metal's natural
// scalar-aligned device-buffer layout rather than the generic default: a
// three-component row is 12 bytes with 4-byte alignment, which MSL spells
// `packed_float3`. The kernel multiplies through the matrix so the unpack
// helper stays live, and CHECK asserts `packed_float3` appears in the
// emitted storage struct.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

struct Xform
{
    float3x3 m;
    float bias;
}

RWStructuredBuffer<Xform> xforms;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float3 v = mul(xforms[tid.x].m, float3(1.0, 2.0, 3.0));
    outBuf[tid.x] = v.x + xforms[tid.x].bias;
}

// CHECK: packed_float3
