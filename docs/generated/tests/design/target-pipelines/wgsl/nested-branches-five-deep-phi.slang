//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#eliminatephis-with-default-options
//META: purpose=Five-level nested if/else with a merged value still lowers via the var+per-branch-assignment pattern of eliminatePhis
//META: intent=stress
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress probe of eliminatePhis under deep nesting (>= 5 levels):
// the merged 'v' still resolves to a single function-local 'var'
// that is assigned in every branch.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = 0;
    if (tid.x > 0u)
    {
        if (tid.y > 0u)
        {
            if (tid.z > 0u)
            {
                if (tid.x > 4u)
                {
                    if (tid.y > 4u) { v = 1; }
                    else { v = 2; }
                }
                else { v = 3; }
            }
            else { v = 4; }
        }
        else { v = 5; }
    }
    else { v = 6; }
    outBuf[tid.x] = v;
}

// CHECK: var v_{{[0-9]+}} : i32
// CHECK: if
// CHECK: else
