//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#specialization-and-generics
//META: purpose=Boundary: a generic with exactly one call-site instantiation produces exactly one concrete specialization — the `### AFTER specializeModule` dump shows a `Func(Float, Float, Float)` signature.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `pickFirst<T>` is called exactly once with `T = float`. After the
// specializeModule pass the function carries a single concrete
// `Func(Float, Float, Float)` signature.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir-after specializeModule -o - -stage compute -entry main

uniform float a;
uniform RWStructuredBuffer<float> buf;

T pickFirst<T>(T x, T y) { return x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = pickFirst(a, a + 1.0f);
}

// CHECK-LABEL: ### AFTER specializeModule:
// CHECK: func %pickFirst{{[^:]*}}: Func(Float, Float, Float)
