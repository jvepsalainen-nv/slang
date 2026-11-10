//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: purpose=Boundary: `fa != fa` on a `uniform float` surfaces `cmpNE(%fa, %fa)` — the NaN-detection idiom is preserved through IR lowering.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The self-compare-not-equal form is the IEEE-754 NaN predicate.
// Verifies that `!=` lowers to `cmpNE`; both operands being the
// same SSA value does not collapse the instruction.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(fa != fa, 1, 0);
}

// IR-LABEL: func %main
// IR: cmpNE(%fa, %fa)
