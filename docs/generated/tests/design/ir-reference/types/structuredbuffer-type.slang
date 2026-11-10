//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A read-only StructuredBuffer<T> uniform lowers to a global_param of IR type StructuredBuffer(<T>, <layout>, ...).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A read-only StructuredBuffer<T> uniform lowers to a global_param of
// IR type StructuredBuffer(<T>, <layout>, ...). A `uniform
// StructuredBuffer<int>` shows up as `StructuredBuffer(Int,
// DefaultLayout, ...)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> src;
uniform RWStructuredBuffer<int> dst;

[numthreads(1, 1, 1)]
void main()
{
    dst[0] = src[0];
}

// IR: let {{.*}}%src{{.*}}: StructuredBuffer(Int{{.*}}= global_param
