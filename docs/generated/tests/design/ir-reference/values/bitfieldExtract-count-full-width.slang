//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: `bitfieldExtract(a, 0, 32)` (full-width extract on a 32-bit `uint`) lowers to `bitfieldExtract(%a, 0 : UInt, 32 : UInt)` — the upper-edge of the bitfield-width range.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The upper-equal edge: count = width of the operand type. The
// inline payload-encoded count is the documented operand layout.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bitfieldExtract(a, 0, 32);
}

// IR-LABEL: func %main
// IR: bitfieldExtract(%a, 0 : UInt, 32 : UInt)
