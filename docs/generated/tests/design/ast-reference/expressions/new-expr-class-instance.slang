//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A NewExpr `new T()` allocates a class instance whose fields are writable and readable back through the resulting reference.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `new` is the allocation form of a call expression and is only meaningful for
// a class (reference) type. A class instance is allocated, a field is written
// from the dispatch id so the value stays symbolic, and the field is read back
// through the same reference into the output buffer. Every target's CHECK
// asserts the stored expression still carries the written constant, which
// requires the allocation and the field round-trip to have been lowered.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

class Counter { int v; }

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    Counter c = new Counter();
    c.v = 9 + int(tid.x);
    outputBuffer[0] = c.v;
    // HLSL: int(9) +
    // GLSL: 9 +
    // SPV: OpIAdd %int %int_9
    // METAL: int(9) +
    // WGSL: i32(9) +
    // CUDA: int(9) +
    // CPP: int(9) +
}
