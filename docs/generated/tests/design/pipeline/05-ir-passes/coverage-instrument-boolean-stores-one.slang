//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#instrumentation
//META: purpose=-trace-coverage-boolean records execution as a non-atomic store of 1 instead of an exact count.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the alternative recording mode, which is the branch that makes
// the Metal width exemption below it coherent. The same shader compiled
// with counting mode emits an atomic add; here the CHECKs assert the
// counter slot is written with a plain assignment of 1 and that no atomic
// add survives at all, which is the "stores rather than accumulates"
// distinction the row draws.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main -trace-coverage -trace-coverage-boolean

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid: SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// HLSL: {{.*}}slang_coverage{{.*}}[int(0)] = 1ULL;
// HLSL-NOT: InterlockedAdd
