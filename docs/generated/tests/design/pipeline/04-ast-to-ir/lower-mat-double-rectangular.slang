//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `matrix<double, 2, 4>` rectangular matrix lowers with IR type `Mat(Double, 2 : Int, 4 : Int, 0 : Enum(Int))`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: combined axes — rectangular shape AND double element.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform matrix<double, 2, 4> m;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = m[0][0];
}

// CHECK: [nameHint("m")]
// CHECK: let {{.*}}m{{.*}}: Mat(Double, 2 : Int, 4 : Int, 0 : Enum(Int)){{.*}}= global_param
