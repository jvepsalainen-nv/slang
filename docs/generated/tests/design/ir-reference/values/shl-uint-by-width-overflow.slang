//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: shift by 32 (`a << 32`) on a 32-bit `uint` still lowers to `shl(%a, 32 : Int)` (one past the documented valid range) — the opcode appears in IR even though semantic-check emits a left-shift-overflow warning. Verifies that lowering proceeds past the warning, leaving the literal payload intact.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// One-past-edge on the shift-amount axis. The compiler emits a
// warning `E41030 left shift overflow` because 32 is not within
// the valid range for the 32-bit operand, but the IR still
// contains the `shl(%a, 32 : Int)` instruction. The boundary test
// asserts that the opcode shape is unchanged in IR by the warning
// path.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a << 32;
}

// IR-LABEL: func %main
// IR: shl(%a, 32 : Int)
