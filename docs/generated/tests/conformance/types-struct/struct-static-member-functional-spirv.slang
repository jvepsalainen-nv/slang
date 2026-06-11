//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#description
//META: doc_section_digest=0b091f4f0ba7cb2a07817dc55025aaaaadee5292438bfc88fba1ab02ee5d3878
//META: purpose=Static data members are allocated from global storage; they are shared across all instances and accessed via the type name (not an instance).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-static-member-functional test. The static
// data member `TestStruct.b` (value 5) is read via the type name and added to a
// runtime thread id so the value cannot be folded entirely away into the store.
// SPV pins the materialized constant `%int_5` consumed by an `OpIAdd`, proving the
// type-name-qualified static member reaches the back-end as its global-storage value.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute

struct TestStruct
{
    int a;
    static int b = 5;
}

RWStructuredBuffer<int> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    output[tid.x] = TestStruct.b + int(tid.x);
}

// SPV-DAG: %int_5 = OpConstant %int 5
// SPV-DAG: OpIAdd %int %int_5 %{{[0-9]+}}
