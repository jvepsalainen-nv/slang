//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#spir-v-literals-and-kinds
//META: purpose=Stress: an instantiation of a generic with a Vec type-argument still surfaces the type_t kind on the generic param.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// an instantiation of a generic with a Vec type-argument still
// surfaces the type_t kind on the generic param. Even when the generic
// is instantiated at a non-trivial type (`float3` here), the generic-
// param's kind in the IR dump is `type_t`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

T pass<T>(T x) { return x; }

uniform float3 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    float3 r = pass<float3>(v);
    buf[0] = r.x;
}

// IR: generic
// IR: param %T {{.*}} type_t
