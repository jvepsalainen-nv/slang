//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `vector<half, 3>` global lowers with IR type `Vec(Half, 3 : Int)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — `half` element inside a 3-wide vector.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<half, 3> v;
uniform RWStructuredBuffer<vector<half, 3>> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = v;
}

// CHECK: [nameHint("v")]
// CHECK: let {{.*}}v{{.*}}: Vec(Half, 3 : Int){{.*}}= global_param
