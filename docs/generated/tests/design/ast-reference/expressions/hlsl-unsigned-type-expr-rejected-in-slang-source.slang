//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#type-expression-family-pointertypeexpr-functypeexpr-tupletypeexpr-andtypeexpr-modifiedtypeexpr-packbranchtypeexpr
//META: purpose=The `unsigned` type specifier is produced only for HLSL source, so a Slang source file that writes `unsigned int` is rejected.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies HLSLUnsignedTypeExpr is HLSL-only: in a `.slang` file (Slang
// language mode) `unsigned` is an ordinary identifier, so `unsigned int a`
// fails to parse and then fails name lookup. CHECK-DAG pins the parse error
// and the undefined-identifier code so an unrelated failure cannot satisfy it.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    unsigned int a = 1u;
    outputBuffer[0] = a;
}

// CHECK-DAG: E20001
// CHECK-DAG: E30015
