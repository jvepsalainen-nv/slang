//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#inlining-and-call-graph
//META: purpose=Boundary: a tiny helper WITHOUT `[ForceInline]` is NOT inlined by the default inline pass — the callee name survives in the HLSL emit. The doc claim is that `[ForceInline]` drives inlining, not size; this is the contrasting baseline.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Contrast with `inline-removes-forceinline-callee-from-emit.slang`:
// without the `[ForceInline]` attribute the inline pass does not
// inline the helper — `addOne` survives in the HLSL emit as a real
// function call.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int addOne(int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = addOne(a);
}

// HLSL: int addOne
// HLSL: void main
// HLSL: addOne
