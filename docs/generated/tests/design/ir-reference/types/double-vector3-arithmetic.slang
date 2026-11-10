//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: vector add on Vec(Double, 3 : Int) operands produces an add whose result type stays Vec(Double, 3 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// vector add on Vec(Double, 3 : Int) operands produces an add whose
// result type stays Vec(Double, 3 : Int). Adding two `double3` globals
// produces a vector `add` whose result is itself a `Vec(Double, 3 :
// Int)` value — confirming the large-element vector arithmetic
// preserves shape and element type at the IR level.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double3 a;
uniform double3 b;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    double3 c = a + b;
    buf[0] = c.x + c.y + c.z;
}

// IR: {{.*}}: Vec(Double, 3 : Int){{.*}}= add(%a, %b)
