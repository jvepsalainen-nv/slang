//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: positive `0.0` literal survives as `0 : Float` on a `mul` operand (the `add` identity collapses `+0`, so `mul` is used to keep the literal observable).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Float zero — the documented "smallest" magnitude. `mul` is used
// because `add(%fa, 0.0)` collapses to `%fa` via the additive
// identity before the IR dump captures it; `mul(%fa, 0.0)` does
// not, so the literal payload remains observable.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = fa * 0.0;
}

// IR-LABEL: func %main
// IR: mul(%fa, 0 : Float)
