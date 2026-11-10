//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=A compute entry point with [numthreads(X,Y,Z)] survives the pipeline as a [numthreads(X, Y, Z)] HLSL attribute on the entry point function.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The HLSL source emitter writes the entry-point's numthreads
// dimensions as the canonical `[numthreads(X, Y, Z)]` attribute
// immediately before `void main(...)`.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 4, 2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: numthreads(8, 4, 2)
// CHECK: void main(uint3 tid_{{[0-9]+}} : SV_DispatchThreadID)
