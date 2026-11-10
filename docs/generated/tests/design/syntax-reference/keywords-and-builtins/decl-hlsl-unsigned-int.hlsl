//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=In HLSL source `unsigned int` and bare `unsigned` are accepted by the type-specifier parser and name the unsigned integer type.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The type-specifier parser's first branch, when the source language is
// HLSL, recognizes `unsigned` through
// `isHLSLTraditionalIntegerTypeSpecifierStart`.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

//CHECK: RWStructuredBuffer<uint >
//CHECK: outBuf_0[int(0)] = tid_0.x + 6U

RWStructuredBuffer<uint> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    unsigned int a = tid.x;
    unsigned b = a + 6;
    outBuf[0] = b;
}
