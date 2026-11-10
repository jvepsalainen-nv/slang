//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: documented `uint` MAX (4294967295) survives lowering as `4294967295 : UInt` on the `add` operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper edge of the unsigned-32 range. The literal payload is
// expected to surface verbatim. Note that `a + 0u` is constant-
// folded away (additive identity) so only the MAX-edge form is
// asserted.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a + 4294967295u;
}

// IR-LABEL: func %main
// IR: add(%a, 4294967295 : UInt)
