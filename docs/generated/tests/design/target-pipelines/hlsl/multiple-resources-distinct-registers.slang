//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Multiple unbound UAVs get sequentially numbered register(uN) annotations on HLSL emit.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two `RWStructuredBuffer<T>` declarations without explicit
// register annotations get two distinct `u` register slots on
// HLSL emit.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> bufA;
RWStructuredBuffer<float> bufB;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bufA[tid.x] = int(tid.x);
    bufB[tid.x] = float(tid.x);
}

// CHECK-DAG: RWStructuredBuffer<int{{.*}}> bufA_{{[0-9]+}} : register(u{{[0-9]+}})
// CHECK-DAG: RWStructuredBuffer<float{{.*}}> bufB_{{[0-9]+}} : register(u{{[0-9]+}})
