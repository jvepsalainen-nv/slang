//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeirformetal
//META: purpose=`SV_GroupIndex` is synthesized in the kernel body from `[[thread_position_in_threadgroup]]` because Metal has no single builtin for the linear in-group index.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the Metal varying-param legalization does not simply
// rename this semantic: Metal exposes the 3-D in-threadgroup position but
// no flattened index, so Slang has to bind the 3-D builtin and compute the
// linear value itself. CHECK asserts the `thread_position_in_threadgroup`
// attribute appears on the kernel, which is the observable evidence that
// the synthesis path (rather than a direct builtin) was taken.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

groupshared int s_data[64];
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint tid : SV_GroupIndex)
{
    s_data[tid] = int(tid);
    outBuf[tid] = s_data[tid];
}

// CHECK: thread_position_in_threadgroup
