//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#natural-layout
//META: doc_section_digest=380aa59bd382916defff5c41e4ce069cc263f0377fbd8a35da604e427f5858d7
//META: purpose=A struct with mixed int/float fields emits with those fields in declaration order (non-static members allocated sequentially in struct).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-natural-layout-emission test. The mixed
// `int x; float y; int z;` struct is stored whole into an RWStructuredBuffer<Mixed>
// so the aggregate survives scalar replacement. SPV-DAG pins the emitted
// `OpTypeStruct %int %float %int` (declaration order preserved: int, float, int)
// and the sequential member offsets 0/4/8 confirming natural sequential allocation.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute

struct Mixed
{
    int x;
    float y;
    int z;
}

RWStructuredBuffer<Mixed> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Mixed m;
    m.x = int(tid.x);
    m.y = float(tid.y);
    m.z = int(tid.z);
    output[tid.x] = m;
}

// SPV-DAG: OpMemberName %Mixed_std430 0 "x"
// SPV-DAG: OpMemberName %Mixed_std430 1 "y"
// SPV-DAG: OpMemberName %Mixed_std430 2 "z"
// SPV-DAG: OpMemberDecorate %Mixed_std430 0 Offset 0
// SPV-DAG: OpMemberDecorate %Mixed_std430 1 Offset 4
// SPV-DAG: OpMemberDecorate %Mixed_std430 2 Offset 8
// SPV-DAG: %Mixed_std430 = OpTypeStruct %int %float %int
