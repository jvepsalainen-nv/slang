//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=A [TorchEntryPoint] returning a non-tensor-mappable type (String) is rejected with E55101.
//META: intent=characterization
//META: covers=source/slang/slang-ir-pytorch-cpp-binding.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the return-type guard in generateCppBindingForFunc
// (slang-ir-pytorch-cpp-binding.cpp:377): when translateToTupleType returns null
// for the function result type (here `string`, which hits the catch-all else at
// line 92), the pass diagnoses InvalidTorchKernelReturnType (E55101) and bails.
// The CHECK pins the error code on the return-type token.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target torch -line-directive-mode none

[TorchEntryPoint]
export __extern_cpp String runCompute()
//CHECK:                   ^^^^^^^^^^ invalid pytorch kernel return type
//CHECK:                   ^^^^^^^^^^ 'string' is not a valid return type for a pytorch kernel function.
{
    return "hello";
}
