//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#inlining-and-call-graph
//META: purpose=The inline pass inlines a `[ForceInline]` callee so its body appears at the call site and the callee no longer appears in the emit.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `[ForceInline]` helper is fully inlined by `slang-ir-inline.cpp`,
// so the emit text does not contain a definition or call to the
// helper. Observable on every text-emit target.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=CUDA):-target cuda -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[ForceInline]
int addOne(int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = addOne(a);
}

// HLSL: void main
// HLSL-NOT: addOne
// GLSL: void main
// GLSL-NOT: addOne
// SPIRV: OpEntryPoint
// SPIRV-NOT: addOne
// CUDA: __global__
// CUDA-NOT: addOne
