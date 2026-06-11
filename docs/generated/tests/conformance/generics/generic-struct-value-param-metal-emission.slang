//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:21:18+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/generics.md#description
//META: doc_section_digest=7b3e1c2f4d8a0e9f5b2c6d1e3f7a4b8c0d2e6f9a1b5c3e7f0d4a8b2c6e0f4a
//META: purpose=A generic compute shader specialized with a value parameter emits valid SPIR-V that can be checked; the entry point and storage buffer are present in the assembly.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Metal fan-out of the value-parameter-specialized compute-shader emission
// claim. `Sized<let N : uint>` specialized at `N=4` emits a concrete Metal
// struct whose member is `array<int, int(4)>` — the value parameter became
// the array bound. CHECK pins the specialized array type and the kernel
// entry, proving the value argument was bound at emit.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

struct Sized<let N : uint>
{
    int data[N];
}

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Sized<4> s;
    s.data[0] = 1;
    s.data[1] = 2;
    s.data[2] = 3;
    s.data[3] = 4;
    outputBuffer[0] = s.data[0] + s.data[3];
}
// CHECK: array<int, int(4)> data_{{[0-9]+}};
// CHECK: kernel
// CHECK-SAME: computeMain
