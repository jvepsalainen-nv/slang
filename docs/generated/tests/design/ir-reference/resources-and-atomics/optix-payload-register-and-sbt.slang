//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#raytracing-payload
//META: purpose=A `closesthit` entry point on `-target cuda` emits `optixGetPayload_N` and `optixSetPayload_N` calls, the user-visible artifact of the `getOptiXPayloadRegister` / `setOptiXPayloadRegister` opcodes that varying-param legalization synthesizes after the IR-dump point.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The payload-register opcodes are synthesized during varying-param
// legalization, which runs after the `-dump-ir` snapshot, so this test
// observes the user-visible artifact instead: the CUDA text a
// `closesthit` entry point emits. The CHECKs pin both the read and the
// write form of the payload-register accessor. The SBT-data pointer is
// not exercised here — for this small scalar uniform the emit folds the
// value rather than performing an SBT lookup (see the bundle README's
// doc-gap row).

//TEST:SIMPLE(filecheck=CHECK):-target cuda -stage closesthit -entry main

struct SmallPayload
{
    float hitT;
    float3 color;
};

struct ShaderRecord
{
    float scale;
};

uniform ShaderRecord sbtRecord;

[shader("closesthit")]
void main(inout SmallPayload payload, BuiltInTriangleIntersectionAttributes attribs)
{
    payload.hitT = RayTCurrent() * sbtRecord.scale;
    payload.color = float3(attribs.barycentrics, 1.0);
}

// CHECK-DAG: optixGetPayload_
// CHECK-DAG: optixSetPayload_
