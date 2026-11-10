//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#func
//META: purpose=Boundary: Func operands preserve param type heterogeneity (mixed scalar/vector/array params).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Func operands preserve param type heterogeneity (mixed
// scalar/vector/array params). A function whose params mix a scalar, a
// vector, and a fixed-size array shows each in the correct slot of the
// `Func(...)` operand list.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform float3 v;
uniform RWStructuredBuffer<float> buf;

float helper(int n, float3 vec, float arr[2])
{
    return float(n) + vec.x + arr[0];
}

[numthreads(1, 1, 1)]
void main()
{
    float arr[2] = { v.y, v.z };
    buf[0] = helper(a, v, arr);
}

// IR-LABEL: func %helper
// IR-SAME: Func(Float, Int, Vec(Float, 3 : Int), Array(Float, 2 : Int))
