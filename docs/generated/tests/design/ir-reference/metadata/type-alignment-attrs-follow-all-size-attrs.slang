//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#typealignment--the-operand-order-exception
//META: purpose=A type layout emits every size attribute before any TypeAlignment attribute, so each attribute kind forms one contiguous run of operands.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the contiguity invariant that attribute enumeration depends on.
// A parameter block whose element struct has both byte-unit data and resources
// produces a struct layout with two size attributes and one alignment
// attribute. The CHECK captures the first three operands positionally and then
// resolves them: interleaving the alignment between the two sizes would put a
// `TypeAlignment` in the second slot and fail the match.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct Params
{
    float4 a;
    Texture2D t;
    SamplerState s;
}

ParameterBlock<Params> gPB;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = gPB.a.x;
}

// CHECK: = structTypeLayout(%[[S0:[0-9]+]], %[[S1:[0-9]+]], %[[AL:[0-9]+]], %{{[0-9]+}}
// CHECK-DAG: %[[S0]]{{.*}}= size(
// CHECK-DAG: %[[S1]]{{.*}}= size(
// CHECK-DAG: %[[AL]]{{.*}}= TypeAlignment(
