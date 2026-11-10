//META: generated=true
//META: doc_ref=docs/language-reference/types-struct.md#nonstatic-member-function
//META: purpose=A non-static member function has a hidden `this` parameter; it may read (but not write) non-static members by default.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a non-static member function can read `this` fields without `[mutating]`.
// getA() returns this.a; buffer output confirms the returned value matches the assigned field.
// Emission tests confirm the member function is emitted on all text-emit backends.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

struct TestStruct
{
    int a;

    int getA()
    {
        return this.a;
    }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    TestStruct obj;
    obj.a = 42;
    outputBuffer[0] = obj.getA();
}

// CHECK: 42

// HLSL: struct TestStruct_{{[0-9_]*}}
// HLSL: int TestStruct_getA_{{[0-9_]*}}(TestStruct_{{[0-9_]*}} this_{{[0-9_]*}})

// GLSL: struct TestStruct_{{[0-9_]*}}
// GLSL: int TestStruct_getA_{{[0-9_]*}}(TestStruct_{{[0-9_]*}} this_{{[0-9_]*}})

// METAL: struct TestStruct_{{[0-9_]*}}
// METAL: int TestStruct_getA_{{[0-9_]*}}(const TestStruct_{{[0-9_]*}} thread* this_{{[0-9_]*}})

// WGSL: struct TestStruct_{{[0-9_]*}}
// WGSL: fn TestStruct_getA_{{[0-9_]*}}( this_{{[0-9_]*}} : TestStruct_{{[0-9_]*}}) -> i32

// CUDA: struct TestStruct_{{[0-9_]*}}
// CUDA: TestStruct_getA_{{[0-9_]*}}

// CPP: struct TestStruct_{{[0-9_]*}}
// CPP: TestStruct_getA_{{[0-9_]*}}
