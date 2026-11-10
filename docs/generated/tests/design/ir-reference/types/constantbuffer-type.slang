//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A ConstantBuffer<T> uniform lowers to a global_param of IR type ConstantBuffer(<T>, <layout>, ...).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A ConstantBuffer<T> uniform lowers to a global_param of IR type
// ConstantBuffer(<T>, <layout>, ...). A `uniform
// ConstantBuffer<float>` shows up as `ConstantBuffer(Float,
// DefaultLayout, ...)` in the IR.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform ConstantBuffer<float> cb;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = cb;
}

// IR: let {{.*}}%cb{{.*}}: ConstantBuffer(Float{{.*}}= global_param
