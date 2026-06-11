//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: doc_section_digest=f394bf1461f5876676bdb5fa5c51feaa920cf5ef0986df9fe1bbf0db976d5a30
//META: purpose=The `Atomic<int>` op family lowers to the matching GLSL builtins `atomicAdd` / `atomicAnd` / `atomicOr` / `atomicXor` / `atomicExchange` / `atomicCompSwap` / `atomicMin` / `atomicMax`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the GLSL leg of the atomic-operations per-op branch (the
// SPIR-V leg lives in `atomic-op-family-spirv-signed.slang`). GLSL names
// CAS `atomicCompSwap` (not `atomicCompareExchange`) and uses one
// `atomicMin`/`atomicMax` spelling for both signedness (unlike SPIR-V's
// SMin/UMin split), so this test pins the GLSL-specific token per op.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

RWStructuredBuffer<Atomic<int> > abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = (int)tid.y;
    int r = 0;
    r += abuf[idx].add(v);
    r += abuf[idx].and(v);
    r += abuf[idx].or(v);
    r += abuf[idx].xor(v);
    r += abuf[idx].exchange(v);
    r += abuf[idx].compareExchange(v, v + 1);
    r += abuf[idx].min(v);
    r += abuf[idx].max(v);
    rwbuf[idx] = r;
}

// GLSL-DAG: atomicAdd(
// GLSL-DAG: atomicAnd(
// GLSL-DAG: atomicOr(
// GLSL-DAG: atomicXor(
// GLSL-DAG: atomicExchange(
// GLSL-DAG: atomicCompSwap(
// GLSL-DAG: atomicMin(
// GLSL-DAG: atomicMax(
