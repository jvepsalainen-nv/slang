//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A RWStructuredBuffer<T> uniform lowers to a global_param of IR type RWStructuredBuffer(<T>, <layout>, ...).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A RWStructuredBuffer<T> uniform lowers to a global_param of IR type
// RWStructuredBuffer(<T>, <layout>, ...). A `uniform
// RWStructuredBuffer<float>` declaration surfaces
// `RWStructuredBuffer(Float, DefaultLayout, ...)` as the IR type of
// its `global_param`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<float> buf;
uniform float a;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a;
}

// IR: let {{.*}}%buf{{.*}}: RWStructuredBuffer(Float{{.*}}= global_param
