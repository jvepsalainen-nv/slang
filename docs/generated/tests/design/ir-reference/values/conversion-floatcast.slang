//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=A precision-changing float-to-float cast lowers to `floatCast`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Conversions table lists `floatCast` as the precision-change
// operator. Casting a `float` to a `half` (narrowing) or to a
// `double` (widening) surfaces it.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<half> hbuf;
uniform RWStructuredBuffer<double> dbuf;

[numthreads(1, 1, 1)]
void main()
{
    hbuf[0] = half(fa);
    dbuf[0] = double(fa);
}

// IR-LABEL: func %main
// IR: floatCast(%fa)
// IR: floatCast(%fa)
