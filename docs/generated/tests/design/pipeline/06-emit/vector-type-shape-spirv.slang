//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#shared-c-like-base
//META: doc_section_digest=9bd773e205e5aa520ee4875c2a6aebc4a9d9aabba8cfac9d3b66489e9488c043
//META: purpose=A Slang `float3` parameter is emitted with the target-native vector spelling: HLSL/Metal `float3`, GLSL `vec3`, WGSL `vec3<f32>`, CUDA `float3 `, CPP `Vector<float, 3>`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the float3 vector-spelling claim onto the SPIR-V text
// target, which the C-like sibling (vector-type-shape-per-target.slang)
// cannot reach. SPIR-V has no named `float3`/`vec3` spelling: the type
// is built structurally as `OpTypeVector` over the 32-bit float scalar.
// CHECK pins the `OpTypeVector %float 3` declaration — SPIR-V's native
// 3-component float vector form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

uniform float3 inV;
RWStructuredBuffer<float3> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inV * 2.0;
}

// CHECK-DAG: %float = OpTypeFloat 32
// CHECK-DAG: %v3float = OpTypeVector %float 3
