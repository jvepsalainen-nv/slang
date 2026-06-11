//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#complex-modifiers-take-arguments
//META: doc_section_digest=80bd4844532fa1dfb157f799dd251a83773921d0d32ca7088915141e5b59809b
//META: purpose=`hitAttributeEXT` is a complex modifier in the raytracing family; an HLSL-style intersection shader that calls `ReportHit` with a user-defined hit-attribute struct lowers to GLSL with a `hitAttributeEXT`-decorated variable and pulls in the `GL_EXT_ray_tracing` extension.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission fan-out for the raytracing hit-attribute claim onto HLSL. The
// sibling `modifier-raytracing-hitattributeext.slang` pins GLSL
// (`hitAttributeEXT`) and SPIR-V (`HitAttribute`). On HLSL the same
// intersection entry point round-trips as an intersection shader that
// calls `ReportHit` with the user struct, so the CHECKs pin the
// `[shader("intersection")]` stage attribute and the `ReportHit` call
// carrying the custom hit-attribute struct. (Metal and WGSL reject this
// raytracing surface at type-check time, E36107 — see the bundle README
// `## Untested claims` unsupported-on-target rows for those targets.)

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage intersection

struct SphereHitAttributes
{
    float3 normal;
};

void main()
{
    float3 o = ObjectRayOrigin();
    float t = RayTMin() + RayTCurrent();

    SphereHitAttributes attrs;
    attrs.normal = o;

    ReportHit(t, 0, attrs);
}

//HLSL-DAG: [shader("intersection")]
//HLSL-DAG: ReportHit(
