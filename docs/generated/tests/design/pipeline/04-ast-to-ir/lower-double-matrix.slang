//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `matrix<double, 4, 4>` global lowers with IR type `Mat(Double, 4 : Int, 4 : Int, 0 : Enum(Int))`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — `double` element inside a 4x4 matrix.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform matrix<double, 4, 4> m;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = m[0][0];
}

// CHECK: [nameHint("m")]
// CHECK: let {{.*}}m{{.*}}: Mat(Double, 4 : Int, 4 : Int, 0 : Enum(Int)){{.*}}= global_param
