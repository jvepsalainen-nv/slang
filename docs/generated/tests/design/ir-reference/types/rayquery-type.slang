//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A RayQuery<flags> local variable surfaces the RayQuery opcode in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A RayQuery<flags> local variable surfaces the RayQuery opcode in the
// IR dump. Declaring `RayQuery<RAY_FLAG_NONE>` in a compute entry
// point surfaces the `RayQuery` opcode in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RaytracingAccelerationStructure accel;
uniform RWStructuredBuffer<uint> outBuffer;

[numthreads(1, 1, 1)]
void main(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    RayQuery<RAY_FLAG_NONE> rayQuery;
    RayDesc rayDesc;
    rayDesc.Origin = float3(0, 0, 0);
    rayDesc.Direction = float3(0, 0, 1);
    rayDesc.TMin = 0.0;
    rayDesc.TMax = 1.0;
    rayQuery.TraceRayInline(accel, RAY_FLAG_NONE, 0xFF, rayDesc);
    outBuffer[0] = dispatchThreadID.x;
}

// IR-LABEL: func %main
// IR: RayQuery
