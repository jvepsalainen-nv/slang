//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#metalpackedvec
//META: purpose=Element extraction from a MetalPackedVec-typed buffer element projects out the scalar element type, as for Vec.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies component extraction still works after the element type of
// a Metal device buffer becomes MetalPackedVec: projecting a component
// must yield the scalar elementType exactly as it does for a plain
// Vec. The kernel stores only the .y component of a packed float3
// element into a scalar output buffer; METAL asserts the packed
// storage type is present and that the emitted kernel performs the .y
// component read (the sole .y access in the program).
//
// Extraction projecting the scalar element type is the general Vec
// behaviour, so the other text-emit back-ends assert the same
// projection off their un-rewritten vector element: HLSL and GLSL
// read `.y` off the loaded element, WGSL reads `.y` off the
// `array<vec3<f32>>` element, and SPIR-V performs an
// `OpCompositeExtract %float ... 1` — a float result out of a
// three-component vector.

//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

StructuredBuffer<float3> positions;
RWStructuredBuffer<float> output;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    output[tid.x] = positions[tid.x].y;
}

// METAL-DAG: packed_float3 device* positions
// METAL-DAG: .y;
// HLSL-DAG: StructuredBuffer<float3 > positions
// HLSL-DAG: .Load({{.*}}).y;
// GLSL-DAG: vec3 _data[]
// GLSL-DAG: ._data[{{.*}}].y;
// WGSL-DAG: : array<vec3<f32>>
// WGSL-DAG: [{{.*}}].y;
// SPIRV-DAG: = OpTypeRuntimeArray %v3float
// SPIRV-DAG: = OpCompositeExtract %float {{.*}} 1
