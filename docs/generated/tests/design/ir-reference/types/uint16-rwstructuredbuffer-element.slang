//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Expansion: RWStructuredBuffer<uint16_t> names UInt16 as its element-type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer<uint16_t> names UInt16 as its element-type
// operand. A `RWStructuredBuffer<uint16_t>` exposes the narrow
// unsigned scalar as the buffer's element-type operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint16_t(0xABCD);
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(UInt16{{.*}}= global_param
