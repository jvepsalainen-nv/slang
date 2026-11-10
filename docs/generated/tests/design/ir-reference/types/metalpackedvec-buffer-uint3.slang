//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#metalpackedvec
//META: purpose=Expansion: MetalPackedVec generalises over the element type; a uint3 device-buffer element emits as packed_uint3.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the MSL rendering of MetalPackedVec is the generic
// packed_T<N> form, not a float-only special case. A
// StructuredBuffer<uint3> element mirrors the documented float3
// example with a different scalar element type; METAL asserts the
// buffer is declared with packed_uint3 storage.
//
// The packing rewrite is Metal-only, so the other text-emit back-ends
// pin the boundary of the claim for the same uint3 element: HLSL
// `uint3`, GLSL `uvec3`, WGSL `vec3<u32>`, and SPIR-V a runtime array
// of `%v3uint` with the 16-byte `ArrayStride` packing would remove.

//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

StructuredBuffer<uint3> counts;
RWStructuredBuffer<uint> output;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint3 c = counts[tid.x];
    output[tid.x] = c.x + c.y + c.z;
}

// METAL: packed_uint3 device* counts
// HLSL: StructuredBuffer<uint3 > counts
// GLSL: uvec3 _data[]
// WGSL: : array<vec3<u32>>
// SPIRV: OpDecorate %_runtimearr_v3uint ArrayStride 16
// SPIRV: = OpTypeRuntimeArray %v3uint
