//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=An [AutoPyBindCUDA] kernel taking a fixed array of vectors generates a __typeinfo__Array__N reflection function named by element count.
//META: intent=characterization
//META: covers=source/slang/slang-ir-pytorch-cpp-binding.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the array path of the [AutoPyBindCUDA] reflection generator.
// markTypeForPyExport tags an array with the literal name "Array"
// (slang-ir-pytorch-cpp-binding.cpp:869), tryGetExportTypeName then builds
// "Array_<elem>_<count>" (line 885), and generateReflectionForType's array case
// (line 945) emits a __typeinfo__ function with "type"/"size" entries. For
// float3[4] the exported name becomes Array__4 (the element vector contributes an
// empty export-name). The CHECKs pin the reflection function name and its pybind
// registration, distinguishing the array reflection path from the struct one.

//TEST:SIMPLE(filecheck=CHECK):-target torch -line-directive-mode none

[AutoPyBindCUDA]
[CudaKernel]
void plainCopy(float3 input[4], TensorView<float> output)
{
    uint3 d = cudaThreadIdx();
    if (d.x >= 1)
        return;
    output[0] = input[0].x;
}

// CHECK-DAG: __typeinfo__Array__4()
// CHECK-DAG: m.def("__typeinfo__Array__4", &__typeinfo__Array__4, "__typeinfo__Array__4");
