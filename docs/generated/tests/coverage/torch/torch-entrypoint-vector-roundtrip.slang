//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=A float3 [TorchEntryPoint] parameter and return both map to a 3-element std::tuple<float, float, float>.
//META: intent=characterization
//META: covers=source/slang/slang-ir-pytorch-cpp-binding.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the IRVectorType branch of translateToTupleType
// (slang-ir-pytorch-cpp-binding.cpp:43): a vector<float,3> expands to a tuple of
// the element type repeated 3 times. The parameter is then rebuilt with
// makeValueFromTargetTuple's vector branch (line 268) and the return value is
// flattened with makeTargetTuple's vector branch (line 145). The CHECK pins the
// emitted host signature where both the float3 parameter and float3 result read
// as std::tuple<float, float, float>.

//TEST:SIMPLE(filecheck=CHECK):-target torch -line-directive-mode none

[TorchEntryPoint]
export __extern_cpp float3 runCompute(float3 input)
{
    return input * 2.0;
}

// CHECK: std::tuple<float, float, float> runCompute(std::tuple<float, float, float> input{{[0-9_]+}})
