//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: widest float-narrowing `double -> half` lowers to a single `floatCast(%da)` with `Half` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Widest precision-narrowing step in the float ladder, the
// reverse of the existing `half -> double` widening boundary.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double da;
uniform RWStructuredBuffer<half> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = half(da);
}

// IR-LABEL: func %main
// IR: floatCast(%da)
