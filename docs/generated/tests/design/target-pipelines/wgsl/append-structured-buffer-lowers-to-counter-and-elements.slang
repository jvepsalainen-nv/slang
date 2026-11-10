//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-b-specialization-and-type-legalization
//META: purpose=lowerAppendConsumeStructuredBuffers runs for WGSL and splits AppendStructuredBuffer<T> into an atomic counter buffer plus an element buffer
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the Phase B `lowerAppendConsumeStructuredBuffers` pass fires
// for WGSL (its `target != HLSL` arm is true here). The single Slang-level
// `AppendStructuredBuffer<uint>` global has no WGSL equivalent, so the pass
// must replace it with two plain storage buffers -- an `atomic` counter and
// an element array -- and rewrite `.Append(v)` into an `atomicAdd` on the
// counter followed by a store into the element array. CHECK pins both
// generated globals and the atomicAdd, which only exist if the pass ran.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;
AppendStructuredBuffer<uint> appBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    appBuf.Append(tid.x);
    outBuf[tid.x] = tid.x;
}

// CHECK-DAG: appBuf_counter_{{[0-9]+}} : array<atomic<i32>>
// CHECK-DAG: appBuf_elements_{{[0-9]+}} : array<u32>
// CHECK: atomicAdd
