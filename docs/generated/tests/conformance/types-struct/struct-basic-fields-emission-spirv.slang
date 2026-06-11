//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#description
//META: doc_section_digest=0b091f4f0ba7cb2a07817dc55025aaaaadee5292438bfc88fba1ab02ee5d3878
//META: purpose=A struct with non-static fields emits as a struct type with those fields on all text-emit backends.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-basic-fields-emission test (which covers
// hlsl/glsl/metal/wgsl/cuda/cpp). On SPIR-V a local struct whose fields are only
// read/written as scalars is scalar-replaced before emit, so the value must escape
// as a whole struct to observe the struct type. Storing a `Point` into an
// RWStructuredBuffer<Point> keeps the aggregate; SPV-DAG pins the emitted
// `OpTypeStruct` with its two `int` members named "x" and "y".

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute

struct Point
{
    int x;
    int y;
}

RWStructuredBuffer<Point> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Point p;
    p.x = int(tid.x);
    p.y = int(tid.y) + 1;
    output[tid.x] = p;
}

// SPV-DAG: OpName %Point_std430 "Point_std430"
// SPV-DAG: OpMemberName %Point_std430 0 "x"
// SPV-DAG: OpMemberName %Point_std430 1 "y"
// SPV-DAG: %Point_std430 = OpTypeStruct %int %int
