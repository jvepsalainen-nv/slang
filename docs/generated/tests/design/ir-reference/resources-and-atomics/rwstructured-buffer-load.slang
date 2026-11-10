//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`RWStructuredBuffer::Load(idx)` surfaces as `rwstructuredBufferLoad(%buf, %idx)`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the rvalue `Load` method on a writable structured
// buffer produces the dedicated load opcode rather than an element
// pointer followed by an ordinary load. The index is thread-derived, and
// the CHECK pins the two-operand form in the user body.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = rwbuf.Load(idx);
    rwbuf[0] = v;
}

// IR-LABEL: func %main
// IR: rwstructuredBufferLoad(%rwbuf, %idx)
