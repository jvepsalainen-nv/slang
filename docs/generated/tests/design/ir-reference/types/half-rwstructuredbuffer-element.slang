//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Expansion: RWStructuredBuffer<half> names Half as its element-type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer<half> names Half as its element-type operand. A
// `RWStructuredBuffer<half>` exposes the narrow floating-point scalar
// as the element-type operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<half> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = half(1.5);
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Half{{.*}}= global_param
