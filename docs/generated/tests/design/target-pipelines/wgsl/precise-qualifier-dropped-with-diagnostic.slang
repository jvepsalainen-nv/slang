//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#wgslsourceemitter-policy-overrides-and-bool-conditioned-values
//META: purpose=The WGSL emitter drops a precise qualifier and reports E56005 instead of emitting a precise keyword
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the WGSLSourceEmitter::emitTempModifiers override. WGSL has no
// `precise` keyword, so rather than emitting one the emitter reports a
// diagnostic naming the target and silently drops the qualifier. The caret
// annotation below is anchored to the multiply-add expression the qualifier
// applies to, and the E56005 code is pinned separately; compilation is
// expected to continue past the report.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    precise float v = float(tid.x) * 2.0f + 1.0f;
//CHECK:                                  ^ 'precise' qualifier is not supported on target 'wgsl'
// CHECK: E56005
    outBuf[tid.x] = v;
}
