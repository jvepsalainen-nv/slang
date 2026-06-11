//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:31:20+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: doc_section_digest=3375fc96f25274ba6b5f61268aab7b799044240063cd3b64ac3928c13a5702fc
//META: purpose=A float3 vector type lowers to target-specific spellings on each text-emit backend.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the SPIR-V spelling of the float3 Vec, the one text-emit target
// the sibling vec-emit-multi-target.slang did not cover. The float3 is held
// in a struct read into a buffer so it escapes DCE; CHECK pins the
// OpTypeVector %float 3 declaration that identifies the float3 element type
// and count in the emitted SPIR-V assembly.

//TEST:SIMPLE(filecheck=CHECKSPV):-target spirv-asm -stage compute -entry main

struct VecHolder { float3 v; }

uniform VecHolder data;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = data.v.x;
}

// CHECKSPV: %v3float = OpTypeVector %float 3
