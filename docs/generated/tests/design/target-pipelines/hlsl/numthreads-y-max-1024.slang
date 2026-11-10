//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Boundary: numthreads with the maximum-documented Y dimension (1024) survives to the HLSL attribute.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: maximum thread-group dim on the Y axis. SM 5.0+
// allows up to 1024 along a single axis. The emitter must echo
// the dim literally.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1024, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.y);
}

// CHECK: numthreads(1, 1024, 1)
