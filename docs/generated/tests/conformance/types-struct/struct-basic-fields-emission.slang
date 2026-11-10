//META: generated=true
//META: doc_ref=docs/language-reference/types-struct.md#description
//META: purpose=A struct with non-static fields emits as a struct type with those fields on all text-emit backends.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission test: verifies that a Slang struct with int fields
// is emitted as a struct type containing those fields on HLSL and GLSL.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL_CHECK):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute -O0
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute

struct Point
{
    int x;
    int y;
}

RWStructuredBuffer<int> output;

[numthreads(1,1,1)]
void main()
{
    Point p;
    p.x = 3;
    p.y = 7;
    output[0] = p.x + p.y;
}

// CHECK: struct Point
// CHECK: int x
// CHECK: int y

// GLSL_CHECK: struct Point_{{[0-9]+}}

// SPIR-V emits Point as an OpTypeStruct of the two int fields. The struct only survives
// to the emitted module at -O0; at default optimization the whole body constant-folds to a
// single store, so the emission claim is pinned on the unoptimized module.
// SPV: OpName %Point "Point"
// SPV: OpMemberName %Point 0 "x"
// SPV: OpMemberName %Point 1 "y"
// SPV: %Point = OpTypeStruct %int %int

// Metal emits struct Point with mangled field names.
// METAL: struct Point_{{[0-9]+}}
// METAL: x_{{[0-9]+}}
// METAL: y_{{[0-9]+}}

// WGSL emits struct Point with WGSL field syntax.
// WGSL: struct Point_{{[0-9]+}}
// WGSL: x_{{[0-9]+}}
// WGSL: y_{{[0-9]+}}

// CUDA emits struct Point with int fields.
// CUDA: struct Point_{{[0-9]+}}
// CUDA: int x_{{[0-9]+}}
// CUDA: int y_{{[0-9]+}}

// CPP emits struct Point with int32_t fields.
// CPP: struct Point_{{[0-9]+}}
// CPP: x_{{[0-9]+}}
// CPP: y_{{[0-9]+}}
