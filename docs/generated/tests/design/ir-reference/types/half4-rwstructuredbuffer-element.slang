//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Expansion: RWStructuredBuffer parameterised by a half4 vector exposes Vec(Half, 4 : Int) as its element-type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer parameterised by a half4 vector exposes Vec(Half,
// 4 : Int) as its element-type operand. A `RWStructuredBuffer<half4>`
// surfaces the full `Vec(Half, 4 : Int)` as the buffer's element-type
// operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<half4> buf;
uniform half4 v;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v;
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Vec(Half, 4 : Int){{.*}}= global_param
