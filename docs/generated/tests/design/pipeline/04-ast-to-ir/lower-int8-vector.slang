//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `vector<int8_t, 4>` global lowers with IR type `Vec(Int8, 4 : Int)` — narrow-int element inside the vector storage form.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — vector with narrow element type.
// Combines the VarDecl-global row with a Vec(...) element IR type.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<int8_t, 4> v;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(v.x);
}

// CHECK: [nameHint("v")]
// CHECK: let {{.*}}v{{.*}}: Vec(Int8, 4 : Int){{.*}}= global_param
