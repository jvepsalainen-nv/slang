//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Constructor-style `float(intVal)` lowers to `castIntToFloat`; `int(floatVal)` lowers to `castFloatToInt`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Conversions table lists `castIntToFloat` (int-to-float
// conversion) and `castFloatToInt` (float-to-int truncation).
// Constructor-style casts on uniform operands surface each.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform float fa;
uniform RWStructuredBuffer<int> buf;
uniform RWStructuredBuffer<float> fbuf;

[numthreads(1, 1, 1)]
void main()
{
    fbuf[0] = float(a);
    buf[0] = int(fa);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%a)
// IR: castFloatToInt(%fa)
