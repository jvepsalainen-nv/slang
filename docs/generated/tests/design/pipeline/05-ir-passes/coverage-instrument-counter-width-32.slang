//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#instrumentation
//META: purpose=Boundary: the caller can opt the coverage counters down to uint, and the command-line surface that selects the width is -trace-coverage-counter-width spelled in bits.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower of the two validated counter widths, driven through
// the named CLI surface rather than the API one. The same shader that
// produces `uint64_t` counters by default must produce `uint` counters
// here, so the CHECKs pin the narrowed element type and the correspondingly
// narrowed atomic-add literal, and assert the 64-bit form is gone.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main -trace-coverage -trace-coverage-counter-width 32

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid: SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// HLSL: RWStructuredBuffer<uint {{.*}}slang_coverage
// HLSL: InterlockedAdd({{.*}}slang_coverage{{.*}}, 1U,
// HLSL-NOT: uint64_t
