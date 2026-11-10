//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[push_constant]` places the constant buffer in the SPIR-V PushConstant storage class instead of a descriptor binding.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the attribute changes where layout puts the parameter rather than
// being a documentation-only marker. CHECK asserts the emitted variable is
// declared `PushConstant`; an ordinary `ConstantBuffer` would be a `Uniform`
// variable with a descriptor binding instead.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

struct PC
{
    int k;
}

[push_constant]
ConstantBuffer<PC> pc;

RWStructuredBuffer<int> outBuf;

[numthreads(1,1,1)]
void main()
{
    outBuf[0] = pc.k;
}

//CHECK: OpVariable %{{[A-Za-z0-9_]+}} PushConstant
