//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: largest-finite `float` literal (~3.40282e+38) survives lowering as `3.40282e+38 : Float` on an `add` operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper-finite edge of the single-precision range. The literal
// payload uses the IR dump's exponent-notation formatting.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = fa + 3.402823466e38;
}

// IR-LABEL: func %main
// IR: add(%fa, 3.40282e+38 : Float)
