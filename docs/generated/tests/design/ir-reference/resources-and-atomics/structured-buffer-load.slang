//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`StructuredBuffer::Load(idx)` (read-only buffer) surfaces as `structuredBufferLoad(%buf, %idx)`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a read-only structured buffer's `Load` produces its own
// opcode, distinct from the writable-buffer load. The index is
// thread-derived and the CHECK names `%sbuf` explicitly, so a lowering
// that reused the writable opcode would not match.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = sbuf.Load(idx);
    rwbuf[idx] = v;
}

// IR-LABEL: func %main
// IR: structuredBufferLoad(%sbuf, %idx)
