//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vectors-matrices-and-composite
//META: purpose=An Atomic<T> field surfaces the Atomic opcode parameterised by its element type in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An Atomic<T> field surfaces the Atomic opcode parameterised by its
// element type in the IR dump. A struct field of type `Atomic<uint>`
// surfaces an `Atomic(UInt)` operand on the field row in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Counter { Atomic<uint> n; }

uniform RWStructuredBuffer<Counter> gBuffer;
uniform RWStructuredBuffer<uint> outBuffer;

[numthreads(1, 1, 1)]
void main()
{
    outBuffer[0] = gBuffer[0].n.load();
}

// IR-LABEL: struct %Counter
// IR: field(%{{.*}}, Atomic(UInt
