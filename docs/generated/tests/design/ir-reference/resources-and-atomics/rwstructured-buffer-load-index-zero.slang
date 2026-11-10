//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`RWStructuredBuffer::Load(0)` (lower-edge index) still surfaces `rwstructuredBufferLoad(%buf, 0 : Int)` per the documented opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: index 0 is the lower edge of legal indices for a
// structured buffer. The opcode shape documented for `Load` should
// still appear with the literal `0 : Int` carried in operand 2.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = rwbuf.Load(0);
    rwbuf[tid.x] = v;
}

// IR-LABEL: func %main
// IR: rwstructuredBufferLoad(%rwbuf, 0 : Int)
