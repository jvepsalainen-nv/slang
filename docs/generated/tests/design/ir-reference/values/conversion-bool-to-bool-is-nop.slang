//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=The Bool-to-Bool cell of the conversion table emits no instruction at all: `bool(b)` returns the operand unchanged, so the named value flows straight into its consumer.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one carve-out in the conversion table that produces no
// opcode. Every other data-carrying cell names a cast instruction, but
// a bool-to-bool cast is a no-op, so lowering hands the consumer the
// original value. `b` is produced by a comparison against a dispatch
// id so it is a real SSA value rather than a literal, and the
// round-tripped `bool(b)` is what steers the `ifElse`. CHECK asserts
// that the branch condition is `%b` itself — the same name the
// comparison defined — which can only hold if no cast inst was
// inserted between them.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bool b = (tid.y != 0);
    bool sameKind = bool(b);
    buf[0] = sameKind ? 2 : 0;
}

// IR-LABEL: func %main
// IR: let  %b	: Bool	= cmpNE(%{{[A-Za-z0-9_]+}}, 0 : UInt)
// IR: ifElse(%b,
