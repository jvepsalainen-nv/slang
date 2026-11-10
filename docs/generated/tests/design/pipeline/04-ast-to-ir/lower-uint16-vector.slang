//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `vector<uint16_t, 2>` global lowers with IR type `Vec(UInt16, 2 : Int)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — vector with `uint16_t` element type
// and a non-canonical (length=2) dimension.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<uint16_t, 2> v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = uint(v.x) + uint(v.y);
}

// CHECK: [nameHint("v")]
// CHECK: let {{.*}}v{{.*}}: Vec(UInt16, 2 : Int){{.*}}= global_param
