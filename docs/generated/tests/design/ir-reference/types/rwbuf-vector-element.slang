//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Boundary: RWStructuredBuffer parameterised by a vector element type names the Vec(...) form as its first operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer parameterised by a vector element type names the
// Vec(...) form as its first operand. A `RWStructuredBuffer<float4>`
// surfaces the full `Vec(Float, 4 : Int)` as its first operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<float4> buf;
uniform float4 v;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v;
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Vec(Float, 4 : Int){{.*}}= global_param
