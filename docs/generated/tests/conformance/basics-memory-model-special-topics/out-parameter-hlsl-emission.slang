//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: purpose=`out` parameter: HLSL emission preserves the `out` keyword on the parameter; the callee performs at least one assignment to the output variable.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an `out` parameter emits with the `out` keyword in HLSL output.
// `writeOut` assigns the result once; CHECK asserts the HLSL signature carries
// `out` and that at least one assignment to the result parameter appears.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> output;

[noinline]
void writeOut(out int result, int factor)
{
    result = factor * 2;
}

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int r = 0;
    int f = output[0];
    writeOut(r, f);
    output[0] = r;
}

// CHECK: void writeOut_{{[0-9]+}}(out int result_{{[0-9]+}},
// CHECK: result_{{[0-9]+}} =

// GLSL: void writeOut_{{[0-9]+}}(out int result_{{[0-9]+}},
// GLSL: result_{{[0-9]+}} =

// MTL: void writeOut_{{[0-9]+}}(int thread* result_{{[0-9]+}},
// MTL: *result_{{[0-9]+}} =

// WGSL: fn writeOut_{{[0-9]+}}( result_{{[0-9]+}} : ptr<function, i32>
// WGSL: (*result_{{[0-9]+}}) =

// SPIRV: %_ptr_Function_int = OpTypePointer Function %int
// SPIRV: %writeOut = OpFunction %void DontInline
// SPIRV: %result = OpFunctionParameter %_ptr_Function_int
// SPIRV: OpStore %result
