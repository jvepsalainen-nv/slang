//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A struct conforming to an interface with a method emits to GLSL with the concrete method directly called; interface specialization produces GLSL with the concrete type's method name.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pins the GLSL emission for an interface-typed parameter that is
// specialized for a concrete type at the call site.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CPUCHECK):-cpu -output-using-type
//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITHLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITSPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITMETAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITWGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITCUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITCPP):-target cpp -entry computeMain -stage compute

interface IProcessor
{
    int process(int x);
}

struct Tripler : IProcessor
{
    int process(int x) { return x * 3; }
}

int applyProc(IProcessor p, int x)
{
    return p.process(x);
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Tripler t;
    outputBuffer[0] = applyProc(t, int(id.x) + 5);
}

// CPUCHECK: 15
// CHECK: Tripler_process
// CHECK: applyProc
// EMITHLSL: Tripler_process
// EMITHLSL: applyProc
// EMITHLSL: numthreads
// EMITSPV: LocalSize
// EMITSPV: OpIMul
// EMITMETAL: Tripler_process
// EMITMETAL: applyProc
// EMITMETAL: kernel
// EMITWGSL: Tripler_process
// EMITWGSL: applyProc
// EMITWGSL: @compute
// EMITCUDA: Tripler_process
// EMITCUDA: applyProc
// EMITCUDA: __global__
// EMITCPP: Tripler_process
// EMITCPP: applyProc
