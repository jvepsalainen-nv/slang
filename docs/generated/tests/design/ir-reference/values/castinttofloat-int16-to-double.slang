//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: small-signed-int to double `int16_t -> double` lowers to `castIntToFloat(%i16a)` with `Double` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Off-diagonal mid-ladder case in the int-to-float matrix.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int16_t i16a;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = double(i16a);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%i16a)
