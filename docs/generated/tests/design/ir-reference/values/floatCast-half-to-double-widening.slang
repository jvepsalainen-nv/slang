//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Boundary: widest float-widening `half -> double` lowers to a `floatCast(%ha)` opcode.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that lowering lumps any precision change under `floatCast`. This
// boundary probe takes the widest available widening step in the
// documented type ladder: `half` (16-bit) to `double` (64-bit).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half ha;
uniform RWStructuredBuffer<double> dbuf;

[numthreads(1, 1, 1)]
void main()
{
    dbuf[0] = double(ha);
}

// IR-LABEL: func %main
// IR: floatCast(%ha)
