//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#nonuniformresourceindex
//META: purpose=`NonUniformResourceIndex(0xFFFFFFFFu)` (UINT_MAX literal) still surfaces as `nonUniformResourceIndex(%i)` with the same uint type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: largest representable uint as the operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint nu = NonUniformResourceIndex(0xFFFFFFFFu);
    rwbuf[nu & 0xff] = tid.x;
}

// IR-LABEL: func %main
// IR: nonUniformResourceIndex({{.*}})
