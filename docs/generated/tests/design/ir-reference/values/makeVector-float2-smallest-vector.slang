//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#aggregate-constructors
//META: purpose=Boundary: `float2(fa, fb)` (smallest documented vector dimension) lowers to `makeVector(%fa, %fb)` with result type `Vec(Float, 2 : Int)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The smoke test covers float3 and float4. This boundary probe
// takes the smallest documented vector size (N=2) on the
// makeVector axis.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform float fb;
uniform RWStructuredBuffer<float2> v2buf;

[numthreads(1, 1, 1)]
void main()
{
    v2buf[0] = float2(fa, fb);
}

// IR-LABEL: func %main
// IR: makeVector(%fa, %fb)
