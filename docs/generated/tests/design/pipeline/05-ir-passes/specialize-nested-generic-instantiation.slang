//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#specialization-and-generics
//META: purpose=Expansion: nested generic instantiation — `outer<T>` calls `inner<T>` — specializes to a concrete chain at depth 3, neither generic shape survives in the emit.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Three-deep generic call chain — `top<T> -> middle<T> -> bottom<T>`.
// The specialize pass must instantiate each generic in the chain.
// All three helpers are `[ForceInline]` so they fully evaporate, but
// before inlining the specializer was responsible for resolving
// `Func(Int, Int)` shapes at every depth.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[ForceInline]
T bottom<T>(T x) { return x; }

[ForceInline]
T middle<T>(T x) { return bottom<T>(x); }

[ForceInline]
T top<T>(T x) { return middle<T>(x); }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = top<int>(a + int(tid.x));
}

// HLSL: void main
// HLSL-NOT: top
// HLSL-NOT: middle
// HLSL-NOT: bottom
