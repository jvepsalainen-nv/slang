//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Expansion: RWStructuredBuffer parameterised by Int8 names the narrow scalar as its element-type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer parameterised by Int8 names the narrow scalar as
// its element-type operand. A `RWStructuredBuffer<int8_t>` shows
// `RWStructuredBuffer(Int8, ...)` as the global_param's IR type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int8_t(3);
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Int8{{.*}}= global_param
