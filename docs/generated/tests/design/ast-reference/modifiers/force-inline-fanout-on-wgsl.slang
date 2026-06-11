//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#compile-time-hint-attributes-loops-branches-opt-levels
//META: doc_section_digest=bb776d675adb7c4e2a9412ec7d3dac41d5686e57228edbe14f81c6b4581f05ae
//META: purpose=`[ForceInline]` on a small helper inlines it into the caller; the helper's name no longer appears in emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `[ForceInline]` claim onto WGSL. After inlining, no separate
// `helper` function survives in emitted WGSL; CHECK confirms the `main` entry
// function is emitted and CHECK-NOT confirms no `helper(` call remains, proving
// the forced inline took effect on this target.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[ForceInline]
int helper(int x)
{
    return x * 2 + 1;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = helper(int(tid.x));
}

//CHECK: fn main(
//CHECK-NOT: helper(
