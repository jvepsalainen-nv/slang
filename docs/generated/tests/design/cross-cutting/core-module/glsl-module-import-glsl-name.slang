//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#glsl-module
//META: purpose=An explicit import glsl retrieves the GLSL builtin module, after which its aliases resolve and lower to the target's own spelling.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the GLSL module is reachable by naming it in an import,
// which is the retrieval path for the builtin module the session
// holds. This file differs from the negative companion only by that
// one import line, so the CHECKs -- the emitted HLSL vector spelling
// and the folded sum -- pin that the import is what brought `vec3`
// into scope rather than any implicit visibility.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

import glsl;

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    vec3 v = vec3(float(tid.x), 1.0, 2.0);
    outBuf[tid.x] = v.x + v.y;
}

// HLSL: void computeMain(
// HLSL: float(tid_{{[0-9]+}}.x) + 1.0f
