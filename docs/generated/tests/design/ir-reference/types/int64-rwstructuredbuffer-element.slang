//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Expansion: RWStructuredBuffer<int64_t> names Int64 as its element-type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer<int64_t> names Int64 as its element-type operand.
// A `RWStructuredBuffer<int64_t>` exposes the 64-bit signed scalar as
// the element-type operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int64_t(1);
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Int64{{.*}}= global_param
