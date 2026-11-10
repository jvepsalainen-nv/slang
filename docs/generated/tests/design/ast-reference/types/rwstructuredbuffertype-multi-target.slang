//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#resource-and-texture-type-families
//META: purpose=An HLSLRWStructuredBufferType uniform requires distinct lowering and binding semantics on every backend; each text-emit target renders it in its own surface form.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// This is the bundle's canonical per-target type-lowering observation.
// One RWStructuredBuffer<int> global is written from a compute entry
// point and the same source is emitted to every feasible text target.
// Each per-target CHECK matches the token that identifies that
// backend's form of the buffer, so a backend that silently lowered it
// like another one would be caught.

//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_CPP):-target cpp -entry main -stage compute

RWStructuredBuffer<int> g_buf;

//CHECK_HLSL: RWStructuredBuffer
//CHECK_GLSL: buffer
//CHECK_SPV: OpTypeRuntimeArray
//CHECK_METAL: device
//CHECK_WGSL: storage
//CHECK_CUDA: g_buf
//CHECK_CPP: g_buf
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    g_buf[tid.x] = int(tid.x);
}
