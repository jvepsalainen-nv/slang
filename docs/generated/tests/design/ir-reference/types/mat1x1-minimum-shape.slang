//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: minimum-shape matrix (matrix<float,1,1>) is typed Mat(Float, 1 : Int, 1 : Int, layout) in the IR.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// minimum-shape matrix (matrix<float,1,1>) is typed Mat(Float, 1 :
// Int, 1 : Int, layout) in the IR. The minimum row/col shape of 1x1
// surfaces `Mat(Float, 1 : Int, 1 : Int, ...)` in the dump. HLSL is the
// target because SPIR-V now rejects 1-row/1-column matrices (E39999).

//TEST:SIMPLE(filecheck=IR):-target hlsl -dump-ir -o - -stage compute -entry main

uniform matrix<float, 1, 1> m;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = m[0][0];
}

// IR: let {{.*}}%m{{.*}}: Mat(Float, 1 : Int, 1 : Int, {{[0-9]+}} : Enum(Int)){{.*}}= global_param
