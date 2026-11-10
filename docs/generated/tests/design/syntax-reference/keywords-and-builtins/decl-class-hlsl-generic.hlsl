//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=In HLSL source `class` is parsed by `ParseStruct` with the full struct grammar, so a generic `class Box<T>` is accepted and its field value reaches the emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// In HLSL source language the parser routes `class` through
// `ParseStruct`, which accepts a generic parameter list. The same
// declaration is rejected in Slang source (see
// `negative-class-generic-slang-source.slang`).

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

//CHECK: outBuf_0[int(0)] = 3.0f
class Box<T>
{
    T v;
};

RWStructuredBuffer<float> outBuf;

[numthreads(1, 1, 1)]
void main()
{
    Box<float> b;
    b.v = 3.0;
    outBuf[0] = b.v;
}
