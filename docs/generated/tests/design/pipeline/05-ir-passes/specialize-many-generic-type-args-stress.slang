//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#specialization-and-generics
//META: purpose=Stress: a generic with four type parameters is specialized cleanly — the four-arg generic shape is replaced by a concrete specialization, no surviving generic indirection.
//META: intent=stress
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Four type parameters in a single generic. The specialize pass must
// resolve all four binders. `[ForceInline]` collapses the helper so
// the name `firstOfFour` does not appear in the emit.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform int ai;
uniform float bf;
uniform uint cu;
uniform int di;
uniform RWStructuredBuffer<int> buf;

[ForceInline]
T1 firstOfFour<T1, T2, T3, T4>(T1 a, T2 b, T3 c, T4 d) { return a; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int r = firstOfFour<int, float, uint, int>(ai, bf, cu, di);
    buf[0] = r + int(tid.x);
}

// HLSL: void main
// HLSL-NOT: firstOfFour
