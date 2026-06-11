//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T09:43:32Z
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#stage-specific-entry-point-attributes
//META: doc_section_digest=5332741d22bd1f66cc006924c76c4414130d880c08abe1915fb243255799a71b
//META: purpose=`[shader("compute")]` marks a function as a compute entry point selectable without -entry.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `[shader("compute")]` entry-point claim onto WGSL. With no
// -entry flag, `csMain` is found via its `[shader]` attribute and emitted as
// a WGSL compute entry; CHECK pins the `@compute` attribute and `fn csMain`
// signature that only appear once the compute entry is selected and lowered.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void csMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = 7;
}

//CHECK-DAG: @compute
//CHECK-DAG: fn csMain
