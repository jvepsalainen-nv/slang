//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#append-and-consume-buffers
//META: purpose=`AppendStructuredBuffer::Append(v)` lowers to `StructuredBufferAppend(%buf, %v)`; `ConsumeStructuredBuffer::Consume()` lowers to `StructuredBufferConsume(%buf)`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the two append/consume methods each lower to their own
// opcode rather than to a shared buffer-write. `Append` is given a
// thread-derived value and `Consume` takes only the buffer, so the two
// CHECKs under `func %main` pin two operands for the first and one for
// the second — the operand counts that distinguish the pair.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform AppendStructuredBuffer<int> abuf;
uniform ConsumeStructuredBuffer<int> cbuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    abuf.Append(idx);
    int c = cbuf.Consume();
    rwbuf[idx] = c;
}

// IR-LABEL: func %main
// IR: StructuredBufferAppend(%abuf, %idx)
// IR: StructuredBufferConsume(%cbuf)
