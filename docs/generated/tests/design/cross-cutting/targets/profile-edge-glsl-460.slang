//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#profiles
//META: purpose=The highest documented GLSL profile (`glsl_460` — top of the GLSL family in slang-profile-defs.h) compiles a vanilla compute shader; the emitted module declares `#version 460`.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Profile upper-edge probe for the GLSL family. `glsl_460` is the top
// of the GLSL PROFILE_VERSION list in slang-profile-defs.h. The
// Profiles section already exercises glsl_450 (mid family); this test
// pins the highest documented version, asserting the back-end emits
// the matching `#version 460` header.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -profile glsl_460 -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 1;
}

// GLSL: #version 460
// GLSL: local_size_x = 1
