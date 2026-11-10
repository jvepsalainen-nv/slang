//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Boundary: same-width signed-to-unsigned `int -> uint` lowers to `intCast(%a)`, even though no bit-width change is involved — the `intCast` opcode covers the signedness-flip step.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Same-width but signedness-changing conversion. Verifies that lowering lumps
// signedness flips under `intCast`; this probe verifies that even
// the zero-bit-width-change case still surfaces the opcode (the
// IR uses the result type to encode the new signedness).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(a);
}

// IR-LABEL: func %main
// IR: intCast(%a)
