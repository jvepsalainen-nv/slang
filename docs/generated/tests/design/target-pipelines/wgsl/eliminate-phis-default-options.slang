//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#eliminatephis-with-default-options
//META: purpose=eliminatePhis with default options replaces phi nodes with an explicit var and per-branch assignments
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL accepts default PhiEliminationOptions: the merged value
// becomes a function-local 'var : T' that is assigned in each
// branch of an if/else.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v;
    if (tid.x > 0u)
    {
        v = 10;
    }
    else
    {
        v = 20;
    }
    outBuf[tid.x] = v;
}

// CHECK: var
// CHECK: if
// CHECK: else
