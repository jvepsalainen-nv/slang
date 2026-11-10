//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#resource-and-shader-io-opcodes
//META: purpose=A read from a read-only `StructuredBuffer<T>` lowers to the documented `structuredBufferLoad(base, index)` opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `structuredBufferLoad`/`rwstructuredBufferStore`
// resource row. Indexing a read-only `StructuredBuffer<int>` lowers to
// the `structuredBufferLoad(base, index)` opcode in the IR dump (the
// read-only sibling that returns a value rather than a pointer).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> in_buf;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = in_buf[0];
}

// IR-LABEL: func %main
// IR: structuredBufferLoad(%inx5Fbuf, 0 : Int)
