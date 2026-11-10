//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: `bitfieldExtract(a, 31, 1)` (top-bit extract on a 32-bit `uint`) lowers to `bitfieldExtract(%a, 31 : UInt, 1 : UInt)` — the high-edge of the offset axis.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The high-edge of the offset axis: offset = width - 1, count = 1.
// This is the canonical "extract the sign bit" pattern on a
// 32-bit unsigned value.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bitfieldExtract(a, 31, 1);
}

// IR-LABEL: func %main
// IR: bitfieldExtract(%a, 31 : UInt, 1 : UInt)
