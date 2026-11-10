//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=A [TorchEntryPoint] struct return flattens to a positional std::tuple and a TorchTensor field maps to torch::Tensor.
//META: intent=characterization
//META: covers=source/slang/slang-ir-pytorch-cpp-binding.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes generatePyTorchCppBinding -> generateCppBindingForFunc on a
// [TorchEntryPoint]. translateToTupleType walks the IRStructType field-by-field
// (slang-ir-pytorch-cpp-binding.cpp:74) flattening {float, TorchTensor<float>}
// into std::tuple<float, torch::Tensor>; the TorchTensor case returns the type
// unchanged (line 19), so it emits as torch::Tensor. The CHECK pins the emitted
// host wrapper signature and the pybind m.def registration that exports it.

//TEST:SIMPLE(filecheck=CHECK):-target torch -line-directive-mode none

struct Result
{
    float a;
    TorchTensor<float> t;
}

[TorchEntryPoint]
export __extern_cpp Result runCompute(TorchTensor<float> input)
{
    Result r;
    r.a = 1.0;
    r.t = input;
    return r;
}

// CHECK: std::tuple<float, torch::Tensor> runCompute(torch::Tensor input{{[0-9_]+}})
// CHECK: m.def("runCompute", &runCompute, "runCompute");
