//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=The late-require-capability pass propagates a capability requirement from `printf` to the GLSL emit's `#extension` line.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Late require capability" row of the layout-and-binding
// category (`slang-ir-late-require-capability.cpp`) propagates
// capability requirements after specialization. A `printf` call in
// GLSL emits `#extension GL_EXT_debug_printf : require`.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main -profile glsl_460

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("dbg %d\n", buf[0]);
}

// GLSL: GL_EXT_debug_printf
