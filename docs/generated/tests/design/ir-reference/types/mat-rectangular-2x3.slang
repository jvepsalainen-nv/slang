//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: rectangular (non-square) matrix surfaces both shape operands distinctly as Mat(Float, 2 : Int, 3 : Int, layout).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// rectangular (non-square) matrix surfaces both shape operands
// distinctly as Mat(Float, 2 : Int, 3 : Int, layout). A non-square
// shape (2x3) verifies that the two shape operands are kept distinct
// in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform matrix<float, 2, 3> m;
uniform float3 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    float2 r = mul(m, v);
    buf[0] = r.x;
}

// IR: let {{.*}}%m{{.*}}: Mat(Float, 2 : Int, 3 : Int, {{[0-9]+}} : Enum(Int)){{.*}}= global_param
