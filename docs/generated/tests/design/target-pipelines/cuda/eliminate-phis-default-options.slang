//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#eliminatephis-with-default-options
//META: purpose=CUDA uses eliminatePhis with default options so an if/else-merged value becomes a named local temporary assigned in each branch.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDA's `eliminatePhis` runs with the default `PhiEliminationOptions`.
// An if/else merge is materialised as a function-local
// variable that is assigned in each branch; nvrtc re-SSA's it.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(2, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int x;
    if (tid.x == 0U)
        x = 100;
    else
        x = 200;
    outBuf[tid.x] = x;
}

// CHECK: int {{[A-Za-z_][A-Za-z0-9_]*}};
// CHECK: if(
// CHECK: = int(100)
// CHECK: else
// CHECK: = int(200)
