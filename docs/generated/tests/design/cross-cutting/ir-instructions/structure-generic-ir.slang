//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#function-and-module-structure
//META: purpose=A generic function declaration lowers to a `generic` inst (type-level computation parent).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `generic`/`IRGeneric` structure row ("Type-level
// computation parent ending in `yield`"). A generic helper `idOf<T>`
// produces a `generic` inst in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

T idOf<T>(T x) { return x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = idOf(a);
}

// IR: generic
