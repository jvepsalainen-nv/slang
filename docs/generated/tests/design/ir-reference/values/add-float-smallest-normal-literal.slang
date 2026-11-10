//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: smallest positive normal `float` (~1.17549e-38) survives lowering as `1.17549e-38 : Float` on an `add` operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-positive-normal edge of the single-precision range. The
// IR dump formats it in exponent notation.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = fa + 1.175494351e-38;
}

// IR-LABEL: func %main
// IR: add(%fa, 1.17549e-38 : Float)
