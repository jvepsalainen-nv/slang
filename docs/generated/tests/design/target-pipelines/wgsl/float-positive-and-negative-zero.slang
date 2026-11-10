//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=A vec2(0.0, -0.0) preserves the distinct positive- and negative-zero bit patterns in the emitted f32 literals
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Zero and negative-zero are distinct IEEE-754 bit patterns; the
// WGSL emitter must keep them apart in the literal text.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float2> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float2(0.0f, -0.0f);
}

// CHECK: vec2<f32>(0.0f, -0.0f)
