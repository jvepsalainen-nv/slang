//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=Using int8_t in a storage-buffer element type emits OpCapability Int8 (the lowest-width signed integer in the per-type-width capability ladder).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the doc names capability emission per type-width. The
// existing bundle pins Int16/Int64/Float16/Float64. This pins Int8
// — the lowest edge of the integer-width axis.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int8_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int8_t(tid.x);
}

// CHECK: OpCapability Int8
