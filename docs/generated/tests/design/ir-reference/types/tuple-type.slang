//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#tuples-packs-and-target-tuples
//META: purpose=A makeTuple call yields a value of IR type tuple_type(<T1>, <T2>, ...).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A makeTuple call yields a value of IR type tuple_type(<T1>, <T2>,
// ...). `makeTuple(a, b)` for a Float and an Int surfaces
// `tuple_type(Float, Int)` as the value's type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float a;
uniform int b;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    var t = makeTuple(a, b);
    buf[0] = t._0 + float(t._1);
}

// IR-LABEL: func %main
// IR: tuple_type(Float, Int){{.*}}= makeTuple(
