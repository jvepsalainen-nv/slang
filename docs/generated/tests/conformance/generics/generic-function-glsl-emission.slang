//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:21:18+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/generics.md#description
//META: doc_section_digest=7b3e1c2f4d8a0e9f5b2c6d1e3f7a4b8c0d2e6f9a1b5c3e7f0d4a8b2c6e0f4a
//META: purpose=A specialized generic function emits as a concrete monomorphized function in HLSL with the bound type replacing the type parameter.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL fan-out of the monomorphized-generic-function emission claim. The
// generic `identity<T>` specialized at `float` lowers to a concrete GLSL
// function whose parameter and return types are `float`. CHECK pins the
// emitted GLSL signature `float identity_N(float ...)` (name mangled, ID wild),
// proving the type parameter was replaced by the bound concrete type.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry computeMain -stage compute

RWStructuredBuffer<float> outputBuffer;

T identity<T>(T x) { return x; }

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    outputBuffer[0] = identity<float>(3.14);
}
// CHECK: float identity_{{[0-9]+}}(float
