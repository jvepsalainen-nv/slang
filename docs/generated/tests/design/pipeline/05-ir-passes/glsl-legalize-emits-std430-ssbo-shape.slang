//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=The GLSL-legalize pass rewrites an `RWStructuredBuffer<T>` into a `layout(std430, binding=N) buffer { T _data[]; }` SSBO shape.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "GLSL legalize" entry in the target-specific lowering table
// (`slang-ir-glsl-legalize.cpp`) rewrites Slang resource shapes into
// GLSL-shaped declarations. An `RWStructuredBuffer<int>` becomes a
// `layout(std430, binding = N) buffer ... { int _data[]; }` SSBO.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 7;
}

// GLSL: layout(std430
// GLSL: buffer
// GLSL: _data[
