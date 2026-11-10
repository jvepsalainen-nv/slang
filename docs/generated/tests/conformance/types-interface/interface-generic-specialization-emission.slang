//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A generic parameterized interface specialized to a concrete type argument emits the concrete method name on every target; the generic type parameter is resolved at compile time with no polymorphic dispatch residue.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a struct conforming to `ITypedReq<int>` produces `TestClass_someFunc`
// in the emitted code on every target (no witness-table dispatch).
// `id.x` input defeats constant folding so SPIRV shows OpIAdd for the addition.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CPUCHECK):-cpu -output-using-type
//TEST:SIMPLE(filecheck=EMITHLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITSPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITMETAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITWGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITCUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=EMITCPP):-target cpp -entry computeMain -stage compute

interface ITypedReq<T>
{
    T someFunc(T param);
}

struct TestClass : ITypedReq<int>
{
    int someFunc(int param)
    {
        return 123 + param;
    }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    TestClass obj;
    outputBuffer[0] = obj.someFunc(int(id.x) + 7);
}

// CPUCHECK: 130
// EMITHLSL: TestClass_someFunc
// EMITGLSL: TestClass_someFunc
// EMITGLSL: local_size_x
// EMITSPV: LocalSize
// EMITSPV: OpIAdd
// EMITMETAL: TestClass_someFunc
// EMITMETAL: kernel
// EMITWGSL: TestClass_someFunc
// EMITWGSL: @compute
// EMITCUDA: TestClass_someFunc
// EMITCUDA: __global__
// EMITCPP: TestClass_someFunc
