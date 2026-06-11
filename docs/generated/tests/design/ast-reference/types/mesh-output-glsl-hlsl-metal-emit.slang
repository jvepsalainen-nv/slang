//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#geometry--and-tessellation-shader-io-types
//META: doc_section_digest=7c904d8992380b74b7c58a3b82c04f1512a6f31a7f5dec239acb5b75fe6f68d7
//META: purpose=The VerticesType and IndicesType (mesh-shader `vertices`/`indices` outputs) carry the documented per-output element type; the SPIR-V backend lowers a mesh entry point with both outputs to a mesh-shader execution mode.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the VerticesType / IndicesType mesh-output emission claim out to
// the GLSL, HLSL, and Metal mesh targets the sibling
// mesh-output-vertices-indices.slang (SPIR-V) does not cover. At a mesh
// entry point the `out vertices` / `out indices` parameters lower to a
// target-specific mesh-output form: GLSL `gl_MeshVerticesEXT` +
// `SetMeshOutputsEXT`, HLSL `SetMeshOutputCounts`, Metal a `metal::mesh<...>`
// object with `set_vertex`/`set_index`. (WGSL has no mesh stage; see
// Untested claims unsupported-on-target wgsl.) Each CHECK pins the token
// that identifies that target's mesh-output lowering, copied verbatim
// from slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage mesh -entry main -profile sm_6_5
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage mesh -entry main -profile sm_6_5
//TEST:SIMPLE(filecheck=METAL):-target metal -stage mesh -entry main -profile sm_6_5

struct Vertex
{
    float4 pos : SV_Position;
};

const static uint MAX_VERTS = 3;
const static uint MAX_PRIMS = 1;

//GLSL: gl_MeshVerticesEXT
//HLSL: SetMeshOutputCounts
//METAL: metal::mesh<
[outputtopology("triangle")]
[numthreads(3, 1, 1)]
void main(
    in uint tig : SV_GroupIndex,
    out vertices Vertex verts[MAX_VERTS],
    out indices uint3 triangles[MAX_PRIMS])
{
    SetMeshOutputCounts(3, 1);

    if (tig < 3)
    {
        Vertex v;
        v.pos = float4(float(tig), 0, 0, 1);
        verts[tig] = v;
    }

    if (tig < 1)
    {
        triangles[tig] = uint3(0, 1, 2);
    }
}
