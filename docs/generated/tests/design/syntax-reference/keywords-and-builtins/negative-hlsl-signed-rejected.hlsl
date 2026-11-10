//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=In HLSL source `signed` is diagnosed (E20021) rather than accepted as an integer type specifier.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Counterpart of `decl-hlsl-unsigned-int.hlsl`: the same HLSL-only branch
// accepts `unsigned` but diagnoses `signed`.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main()
{
    //CHECK: E20021
    signed int a = 5;
    outBuf[0] = a;
}
