//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=A `[[vk::binding(...)]]` attribute on an entry-point parameter is reported (E38010) when the compile target would drop it.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the gated case of the ignored-binding-modifier check. The compile
// target is HLSL, which has no notion of a Vulkan binding on an entry-point
// parameter, so the gate opens and the attribute is reported. CHECK pins
// E38010 and the attribute name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK): -target hlsl

[shader("compute")]
[numthreads(1, 1, 1)]
void main([[vk::binding(2)]] uniform RWStructuredBuffer<int> buf)
//CHECK: E38010
//CHECK: attribute '[[vk::binding(...)]]' on parameter 'buf'
{
    buf[0] = 1;
}
