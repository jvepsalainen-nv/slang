//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:21:18+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/generics.md#description
//META: doc_section_digest=7b3e1c2f4d8a0e9f5b2c6d1e3f7a4b8c0d2e6f9a1b5c3e7f0d4a8b2c6e0f4a
//META: purpose=A specialized generic struct emits as a monomorphized concrete struct in HLSL; the type parameter is replaced by the concrete type and the struct name is mangled.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Metal fan-out of the monomorphized-generic-struct emission claim. `Pair<T>`
// specialized at `float` emits as a concrete Metal struct `Pair_N` with two
// `float` members. CHECK pins the mangled struct name and the `float` member
// type, proving the type parameter was substituted.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry computeMain -stage compute

RWStructuredBuffer<float> outputBuffer;

struct Pair<T>
{
    T first;
    T second;
}

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Pair<float> p;
    p.first  = 1.0;
    p.second = 2.0;
    outputBuffer[0] = p.first + p.second;
}
// CHECK: struct Pair_{{[0-9]+}}
// CHECK: float first_{{[0-9]+}};
