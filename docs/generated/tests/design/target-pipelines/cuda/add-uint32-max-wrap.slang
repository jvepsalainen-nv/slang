//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies the CUDA emit writes uint(0xFFFFFFFF) as the 4294967295U literal and forms the wrap-add expression with a thread-derived operand.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: unsigned MAX as a literal in CUDA emit. The constant
// folds to `4294967295U` and the second operand is taken from
// `SV_DispatchThreadID` so the compound add expression survives.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint a = uint(0xFFFFFFFFu);
    outBuf[tid.x] = a + tid.x;
}

// CHECK: 4294967295U
