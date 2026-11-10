//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=The first struct member always receives OpMemberDecorate ... 0 Offset 0 (lower edge of the offset space).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: lower edge of the struct-member Offset decoration
// (member 0 lives at byte offset 0).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

struct Pair { float4 a; float4 b; }
RWStructuredBuffer<Pair> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Pair p;
    p.a = float4(1, 2, 3, 4);
    p.b = float4(5, 6, 7, 8);
    outBuf[tid.x] = p;
}

// CHECK: OpMemberDecorate %Pair{{[a-zA-Z_0-9]*}} 0 Offset 0
