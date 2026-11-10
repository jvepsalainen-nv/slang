//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#layout-and-binding
//META: purpose=A global parameter declared with a register(uN) binding lowers to a HasExplicitHLSLBinding decoration on the parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `HasExplicitHLSLBinding` is the nullary marker recording
// that a global parameter was given an explicit register binding. The
// parameter also carries `[[vk::binding(3, 0)]]` so the SPIR-V target does
// not warn about a D3D register without a Vulkan binding; the CHECK pins
// the bare decoration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

[[vk::binding(3, 0)]]
uniform RWStructuredBuffer<int> buf : register(u3);

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [HasExplicitHLSLBinding]
