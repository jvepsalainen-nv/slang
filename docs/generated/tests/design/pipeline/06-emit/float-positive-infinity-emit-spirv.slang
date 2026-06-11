//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#shared-c-like-base
//META: doc_section_digest=9bd773e205e5aa520ee4875c2a6aebc4a9d9aabba8cfac9d3b66489e9488c043
//META: purpose=Boundary: +infinity (1.0/0.0) is emitted as each target's native infinity spelling — CUDA uses SLANG_INFINITY, WGSL uses _slang_getInfinity, HLSL/GLSL/Metal/CPP emit the literal division.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the +infinity boundary claim onto the SPIR-V text target,
// which the C-like sibling (float-positive-infinity-emit-per-target.slang)
// cannot reach. SPIR-V has no infix `1.0/0.0`: the emitter constant-folds
// the division to +inf and materializes it as an `OpConstant %float` hex
// literal. CHECK pins the folded +inf constant `0x1p+128` — SPIR-V's
// native infinity form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 1.0 / 0.0;
}

// CHECK: %float_0x1p_128 = OpConstant %float 0x1p+128
