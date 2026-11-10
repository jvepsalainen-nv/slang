//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: narrowing conversion from a Vec(Double, 4) to a Vec(Float, 4) yields a floatCast whose result is the narrower-element vector.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// narrowing conversion from a Vec(Double, 4) to a Vec(Float, 4) yields
// a floatCast whose result is the narrower-element vector. Casting a
// `double4` to a `float4` produces a `floatCast` whose result type is
// `Vec(Float, 4 : Int)` — same element count, new element type —
// confirming that elementwise conversion is encoded at the vector
// level.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double4 v;
uniform RWStructuredBuffer<float4> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float4(v);
}

// IR: {{.*}}: Vec(Float, 4 : Int){{.*}}= floatCast(%v)
