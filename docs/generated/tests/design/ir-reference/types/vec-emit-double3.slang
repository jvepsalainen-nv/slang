//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T12:29:46+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: doc_section_digest=3375fc96f25274ba6b5f61268aab7b799044240063cd3b64ac3928c13a5702fc
//META: purpose=Per-element-type Vec emission: a vectorN lowers to the element-type-specific vector spelling on the shared SPIR-V/GLSL legalize path.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-element-type branch of Vec emission for the 64-bit float element.
// The doc names Vec(elementType, elementCount) generically; this pins the
// 64-bit float cell of that family on the shared SPIR-V/GLSL legalize path. The
// double3 value is held in a struct read into a buffer so the vector type
// escapes DCE. CHECKSPV pins the OpTypeVector declaration naming the 64-bit float
// scalar element; CHECKGLSL pins dvec3, the GLSL 64-bit float-vector spelling.

//TEST:SIMPLE(filecheck=CHECKSPV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=CHECKGLSL):-target glsl -stage compute -entry main

struct VecHolder { double3 v; }

uniform VecHolder data;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = data.v.x;
}

// CHECKSPV: %v3double = OpTypeVector %double 3
// CHECKGLSL: dvec3
