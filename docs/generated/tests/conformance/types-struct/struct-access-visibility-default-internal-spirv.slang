//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#description
//META: doc_section_digest=0b091f4f0ba7cb2a07817dc55025aaaaadee5292438bfc88fba1ab02ee5d3878
//META: purpose=Members declared with `public` visibility are accessible from outside the struct; default member visibility is `internal`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-access-visibility-default-internal test.
// Both the explicit `public` field and the default (internal) field are written
// from the entry point, then the whole struct is stored into RWStructuredBuffer<MyStruct>
// so the aggregate survives. SPV-DAG confirms both field names survive to the
// emitted SPIR-V struct type, proving visibility does not strip the internal field
// from the emitted layout when it is used.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute

public struct MyStruct
{
    public int publicField;
    int defaultField;  // internal by default
}

RWStructuredBuffer<MyStruct> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    MyStruct s;
    s.publicField = int(tid.x);
    s.defaultField = int(tid.y);
    output[tid.x] = s;
}

// SPV-DAG: OpName %MyStruct_std430 "MyStruct_std430"
// SPV-DAG: OpMemberName %MyStruct_std430 0 "publicField"
// SPV-DAG: OpMemberName %MyStruct_std430 1 "defaultField"
// SPV-DAG: %MyStruct_std430 = OpTypeStruct %int %int
