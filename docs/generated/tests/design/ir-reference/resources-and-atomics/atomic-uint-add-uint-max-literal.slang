//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<uint>::add(UINT_MAX)` (`0xFFFFFFFFu`) still lowers to the documented `atomicAdd` opcode shape with the value carried as `UInt`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: largest representable 32-bit unsigned integer.
// Runtime wrap semantics are well-defined for unsigned but the
// IR-opcode doc does not encode this — only the opcode shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<uint>> abuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint prev = abuf[idx].add(0xFFFFFFFFu);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicAdd(%{{[^,]+}}, 4294967295 : UInt, {{.*}})
