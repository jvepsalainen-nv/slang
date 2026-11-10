//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: shift by 31 (`a << 31`) on a 32-bit `uint` lowers to `shl(%a, 31 : Int)` — the documented "width minus one" valid edge.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper-valid edge of the shift-amount axis on a 32-bit unsigned
// value. The literal amount survives as the inline payload on the
// `shl` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a << 31;
}

// IR-LABEL: func %main
// IR: shl(%a, 31 : Int)
