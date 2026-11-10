//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: small-int `uint8_t -> float` lowers to a single `castIntToFloat(%u8a)` with `Float` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Small-int int-to-float surface — does not first widen to
// uint32 then convert; the lowering surfaces a single
// `castIntToFloat` regardless of the source integer width.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint8_t u8a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(u8a);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%u8a)
