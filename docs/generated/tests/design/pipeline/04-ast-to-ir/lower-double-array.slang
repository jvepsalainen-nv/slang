//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A fixed-size array of `double` global lowers with IR type `Array(Double, N : Int)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — `double` element inside a fixed-size array.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double arr[2];
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = arr[0] + arr[1];
}

// CHECK: [nameHint("arr")]
// CHECK: let {{.*}}arr{{.*}}: Array(Double, 2 : Int){{.*}}= global_param
