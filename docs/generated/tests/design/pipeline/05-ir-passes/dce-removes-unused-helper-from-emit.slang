//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#ssa-construction-and-basic-cleanup
//META: purpose=The DCE pass removes a top-level helper function that is never called from any reachable code.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A file-scope `unusedHelper` is never called from `main`. The
// `eliminateDeadCode` pass listed under "SSA construction and basic
// cleanup" removes it before emit, so no emit target retains a
// reference to it.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=CUDA):-target cuda -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int unusedHelper(int v) { return v * 99; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + 1;
}

// HLSL: void main
// HLSL-NOT: unusedHelper
// GLSL: void main
// GLSL-NOT: unusedHelper
// SPIRV: OpEntryPoint
// SPIRV-NOT: unusedHelper
// CUDA: __global__
// CUDA-NOT: unusedHelper
