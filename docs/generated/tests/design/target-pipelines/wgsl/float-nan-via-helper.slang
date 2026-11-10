//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=A NaN-producing expression (0.0/0.0) emits via the _slang_getNan helper because WGSL has no nan literal
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL has no surface syntax for IEEE-754 NaN; the emitter
// synthesises a helper function _slang_getNan that returns the
// value via 0.0f / 0.0f.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float nan = 0.0f / 0.0f;
    outBuf[tid.x] = nan;
}

// CHECK: fn _slang_getNan
// CHECK: _slang_getNan()
