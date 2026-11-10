//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#raytracing-payload
//META: purpose=`CallShader(idx, payload)` from a `raygeneration` entry point emits `OpDecorate %p Location 0` alongside `OpCapability RayTracingKHR`, the SPIR-V artifact of the `GetVulkanRayTracingPayloadLocation` opcode that SPIR-V legalization synthesizes after the IR-dump point.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The payload-location opcode is created during SPIR-V target
// legalization, after the `-dump-ir` snapshot, so this test observes
// the assembly it produces. A `raygeneration` entry point with a
// callable payload makes the legalizer assign a location, and the
// CHECKs pin the resulting `Location` decoration together with the
// raytracing capability that must accompany it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -stage raygeneration -entry main

struct CallablePayload
{
    float3 color;
};

[shader("raygeneration")]
void main()
{
    CallablePayload payload;
    payload.color = float3(0.0, 0.0, 0.0);
    CallShader(0, payload);
}

// CHECK-DAG: OpCapability RayTracingKHR
// CHECK-DAG: OpDecorate %p Location 0
