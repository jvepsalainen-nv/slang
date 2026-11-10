//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: documented `int64_t` MAX (9223372036854775807) survives lowering as `9223372036854775807 : Int64` on the `add` operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper edge of the signed-64 range. The integer literal stays in
// 64-bit form and rides as the inline payload of an `add`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t a;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a + 9223372036854775807;
}

// IR-LABEL: func %main
// IR: add(%a, 9223372036854775807 : Int64)
