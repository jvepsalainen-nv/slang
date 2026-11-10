//META: generated=true
//META: doc_ref=docs/language-reference/types-struct.md#description
//META: purpose=A struct may conform to one or more interface types; the struct implements the interface requirements and can be used wherever the interface is expected.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a struct conforming to an interface satisfies a generic constraint.
// MyStruct : IHasValue provides getValue(); readValue<T:IHasValue> calls it. Buffer output
// confirms the concrete value flows back through the generic call. Emission tests confirm
// the struct and its method are emitted on all text-emit backends.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

interface IHasValue
{
    int getValue();
}

struct MyStruct : IHasValue
{
    int data;

    int getValue()
    {
        return data;
    }
}

int readValue<T : IHasValue>(T obj)
{
    return obj.getValue();
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    MyStruct s;
    s.data = 77;
    int v = readValue(s);
    outputBuffer[0] = v;
}

// CHECK: 77

// HLSL: struct MyStruct_{{[0-9_]*}}
// HLSL: int data_{{[0-9_]*}}
// HLSL: MyStruct_getValue_{{[0-9_]*}}

// GLSL: struct MyStruct_{{[0-9_]*}}
// GLSL: int data_{{[0-9_]*}}
// GLSL: MyStruct_getValue_{{[0-9_]*}}

// METAL: struct MyStruct_{{[0-9_]*}}
// METAL: int data_{{[0-9_]*}}
// METAL: MyStruct_getValue_{{[0-9_]*}}

// WGSL: struct MyStruct_{{[0-9_]*}}
// WGSL: data_{{[0-9_]*}}
// WGSL: fn MyStruct_getValue_{{[0-9_]*}}

// CUDA: struct MyStruct_{{[0-9_]*}}
// CUDA: int data_{{[0-9_]*}}
// CUDA: MyStruct_getValue_{{[0-9_]*}}

// CPP: struct MyStruct_{{[0-9_]*}}
// CPP: data_{{[0-9_]*}}
// CPP: MyStruct_getValue_{{[0-9_]*}}
