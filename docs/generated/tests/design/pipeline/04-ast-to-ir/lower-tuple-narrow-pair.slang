//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `Tuple<half, uint16_t>` lowers to `tuple_type(Half, UInt16)` — narrow-precision pair carries through tuple IR type.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: heterogeneous tuple over two narrow types.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half a;
uniform uint16_t b;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Tuple<half, uint16_t> t = makeTuple(a, b);
    buf[0] = float(t._0) + float(t._1);
}

// CHECK-LABEL: func %main
// CHECK: tuple_type(Half, UInt16){{.*}}= makeTuple
