//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#hlsl-compatibility-declarations
//META: purpose=`CBufferDecl` parses as `'cbuffer' IDENT ':' Register '{' StructMember* '}'` with a `register(...)` clause.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the CBufferDecl production including the optional
// `':' Register` clause. The HLSL back-end round-trips the construct,
// so asserting that the emitted text still declares a `cbuffer` bound
// to `register(b3)` — and that the member declared inside the braces
// survived as a field — proves the whole production was parsed rather
// than a prefix of it.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry computeMain

cbuffer Params : register(b3)
{
    int scale;
}

RWStructuredBuffer<int> outputBuffer;

// CHECK-DAG: int scale_{{[0-9]+}};
// CHECK-DAG: cbuffer Params_{{[0-9]+}} : register(b3)
[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = scale;
}
