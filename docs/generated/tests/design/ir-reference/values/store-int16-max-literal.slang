//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: documented `int16_t` MAX (32767) and MIN (-32768) survive lowering as `32767 : Int16` and `-32768 : Int16` on the `store` operands.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Both edges of the signed-16 range on the literal-payload axis.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int16_t(32767);
    buf[1] = int16_t(-32768);
}

// IR-LABEL: func %main
// IR: store(%{{.*}}, 32767 : Int16)
// IR: store(%{{.*}}, -32768 : Int16)
