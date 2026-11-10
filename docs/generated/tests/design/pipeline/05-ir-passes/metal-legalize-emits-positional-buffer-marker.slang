//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=The Metal-legalize pass attaches positional `[[buffer(N)]]` annotations and `kernel` markers to the entry point.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Metal legalize" entry in the target-specific lowering table
// (`slang-ir-metal-legalize.cpp`) rewrites entry-point parameters
// to use Metal's positional `[[buffer(N)]]` binding model with a
// `kernel` qualifier. Per `_common.md`, `[[...]]` is FileCheck
// variable syntax; match the bare token instead.

//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 7;
}

// METAL: kernel
// METAL-SAME: thread_position_in_grid
// METAL-SAME: buffer(0)
