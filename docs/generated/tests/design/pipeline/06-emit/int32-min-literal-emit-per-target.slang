//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#shared-c-like-base
//META: purpose=Boundary: the `int` minimum `-2147483648` survives literal emission on every backend — the C-like targets wrap it in an `int(...)` cast, GLSL emits the bare literal, WGSL wraps it in `i32(...)`, and SPIR-V encodes it as an `OpConstant %int`.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower edge of the signed 32-bit literal axis at the emit
// boundary. `-2147483648` is the one signed value whose positive counterpart
// is not representable, so a backend that emitted it as a negation of a
// positive literal would overflow in the downstream compiler. CHECK asserts
// each backend's spelling still carries the full magnitude and the sign.
// The value is stored into a buffer so it cannot be eliminated.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = -2147483648;
}

// HLSL: int(-2147483648)
// GLSL: = -2147483648;
// SPIRV: OpConstant %int -2147483648
// METAL: int(-2147483648)
// WGSL: i32(-2147483648)
// CUDA: int(-2147483648)
// CPP: int(-2147483648)
