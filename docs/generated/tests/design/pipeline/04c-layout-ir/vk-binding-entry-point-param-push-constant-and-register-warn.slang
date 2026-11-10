//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#explicit-vkbinding-on-entry-point-parameters
//META: purpose=The unsupported-entry-point-parameter-modifier warning E38010 is also raised for [[vk::push_constant]] and register on entry-point parameters, not only vk::binding.
//META: intent=negative
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's statement that the E38010 diagnostic also covers
// `[[vk::push_constant]]` and `register` on entry-point parameters. Both
// annotations are written on one entry point; each must draw its own
// warning naming the offending keyword/attribute, so neither is silently
// dropped.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

struct P { int x; }

[numthreads(1, 1, 1)]
void main([[vk::push_constant]] uniform ConstantBuffer<P> pc, uniform StructuredBuffer<int> b : register(t5))
//CHECK:                                                  ^^ modifier on entry point parameter is unsupported
//CHECK:                                                  ^^ attribute '[[vk::push_constant]]' on parameter 'pc' is unsupported on entry point parameters and will be ignored
//CHECK:                                                                                    ^ modifier on entry point parameter is unsupported
//CHECK:                                                                                    ^ keyword 'register' on parameter 'b' is unsupported on entry point parameters and will be ignored
{
    outBuf[0] = pc.x + b[0];
}
