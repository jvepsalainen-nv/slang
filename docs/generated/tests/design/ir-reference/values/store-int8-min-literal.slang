//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: documented `int8_t` MIN (-128) survives lowering as `-128 : Int8` on the `store` operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower edge of the signed-8 range. The literal payload appears
// as `-128 : Int8` directly on the `store` of the narrow integer.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int8_t(127);
    buf[1] = int8_t(-128);
}

// IR-LABEL: func %main
// IR: store(%{{.*}}, 127 : Int8)
// IR: store(%{{.*}}, -128 : Int8)
