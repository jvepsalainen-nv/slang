//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#specialization-and-generics
//META: purpose=Boundary: a generic function with zero call-site instantiations is dead — neither the generic body nor any specialization appears in the emit.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `uncalled<T>` is a fully-formed generic with no instantiations in
// the program. The specialize / DCE combination removes it before
// emit — neither the generic shape nor a specialized copy survives.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

T uncalled<T>(T x, T y) { return x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + 1;
}

// HLSL: void main
// HLSL-NOT: uncalled
// SPIRV: OpEntryPoint
// SPIRV-NOT: uncalled
