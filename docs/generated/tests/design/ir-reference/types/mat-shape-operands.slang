//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=A matrix value is typed Mat(elementType, rowCount, columnCount, layout) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A matrix value is typed Mat(elementType, rowCount, columnCount,
// layout) in the IR dump. A `float4x4` uniform shows the full four-
// operand form in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float4x4 m;
uniform float4 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    float4 r = mul(m, v);
    buf[0] = r.x;
}

// IR: let {{.*}}%m{{.*}}: Mat(Float, 4 : Int, 4 : Int, {{[0-9]+}} : Enum(Int)){{.*}}= global_param
