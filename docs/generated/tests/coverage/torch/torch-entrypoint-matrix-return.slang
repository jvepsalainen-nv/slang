//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=A float2x2 [TorchEntryPoint] value maps to a nested std::tuple of two row tuples, each of two floats.
//META: intent=characterization
//META: covers=source/slang/slang-ir-pytorch-cpp-binding.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the IRMatrixType branch of translateToTupleType
// (slang-ir-pytorch-cpp-binding.cpp:21): a matrix is lowered to a tuple of row
// tuples (rowCount tuples, each colCount elements). For float2x2 this is
// std::tuple<std::tuple<float,float>, std::tuple<float,float>>. The return path
// uses makeTargetTuple's matrix branch (line 108) and the param path uses
// makeValueFromTargetTuple's matrix branch (line 236, the only branch that
// SLANG_ASSERTs row/col are int-literals). The CHECK pins the nested host shape.

//TEST:SIMPLE(filecheck=CHECK):-target torch -line-directive-mode none

[TorchEntryPoint]
export __extern_cpp float2x2 runCompute(float2x2 input)
{
    return input;
}

// CHECK: std::tuple<std::tuple<float, float>, std::tuple<float, float>> runCompute(std::tuple<std::tuple<float, float>, std::tuple<float, float>> input{{[0-9_]+}})
