//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `double -> float` precision-narrowing lowers to `floatCast(%da)` with `Float` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Middle rung of the float ladder: 64-bit to 32-bit narrowing.
// The doc's "float-to-float cast (precision change)" wording
// places this under the same `floatCast` opcode as half<->float
// transitions.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double da;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(da);
}

// IR-LABEL: func %main
// IR: floatCast(%da)
