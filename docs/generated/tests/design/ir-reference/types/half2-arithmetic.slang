//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: vector add on Vec(Half, 2 : Int) operands yields an add whose result type stays Vec(Half, 2 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// vector add on Vec(Half, 2 : Int) operands yields an add whose result
// type stays Vec(Half, 2 : Int). Adding two `half2` globals produces a
// vector `add` whose result is a `Vec(Half, 2 : Int)` value —
// arithmetic on the smallest multi-element half vector preserves both
// width and shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half2 a;
uniform half2 b;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    half2 c = a + b;
    buf[0] = float(c.x) + float(c.y);
}

// IR: {{.*}}: Vec(Half, 2 : Int){{.*}}= add(%a, %b)
