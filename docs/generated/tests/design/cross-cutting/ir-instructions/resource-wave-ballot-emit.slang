//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#resource-and-shader-io-opcodes
//META: purpose=`WaveActiveBallot` is a wave intrinsic taking a per-lane condition and emits as each target's subgroup ballot.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `waveGetActiveMask / waveMaskBallot / ...` wave-intrinsic
// row, including its note that the operand shape varies by opcode — the
// ballot form takes a condition operand. The condition is derived from
// `SV_DispatchThreadID` compared against a `uniform`, so it is genuinely
// per-lane and cannot fold to a constant mask. Each CHECK asserts the
// target's ballot spelling (SPIR-V additionally declares the
// `GroupNonUniformBallot` capability, which is what the wave family costs on
// that target). The `cpp` kernel target is excluded: it has no wave.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main
//TEST:SIMPLE(filecheck=CUDA):-target cuda -stage compute -entry main

uniform RWStructuredBuffer<uint> outbuf;
uniform uint threshold;

[numthreads(32, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bool p = tid.x > threshold;
    uint4 ballot = WaveActiveBallot(p);
    outbuf[tid.x] = ballot.x;
}

// HLSL: WaveActiveBallot(
// GLSL: subgroupBallot(
// SPV-DAG: OpCapability GroupNonUniformBallot
// SPV-DAG: OpGroupNonUniformBallot %v4uint
// METAL: simd_ballot(
// WGSL: subgroupBallot(
// CUDA: __ballot_sync(
