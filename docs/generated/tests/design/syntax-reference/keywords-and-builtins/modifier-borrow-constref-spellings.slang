//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#simple-modifiers
//META: purpose=`__borrow` and `__constref` are two spellings of the same BorrowModifier; a parameter written with either is accepted and both reach the emitted call.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The simple-modifiers table lists `__borrow` and `__constref` as both
// mapping to `BorrowModifier`. One parameter of each spelling is used.

//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK_SPIRV):-target spirv-asm -entry main -stage compute

//CHECK_HLSL: inc_0(a_0, a_0)
//CHECK_GLSL: inc_0(a_0, a_0)
//CHECK_METAL: inc_0(&a_0, &a_0, &kernelContext_1)
//CHECK_WGSL: inc_0(&(a_0), &(a_0))
// SPIR-V inlines the call; both spellings still sum their parameters.
//CHECK_SPIRV: OpIAdd %int

RWStructuredBuffer<int> outBuf;

void inc(__borrow int x, __constref int y)
{
    outBuf[1] = x + y;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = int(tid.x);
    inc(a, a);
}
