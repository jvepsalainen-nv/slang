//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=WGSL emit selects LineDirectiveMode::None so the output contains no #line directives
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL has no #line syntax, so emitEntryPointsSourceFromIR sets
// LineDirectiveMode::None and no '#line' marker appears in the
// emitted text.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 42;
}

// CHECK: @compute
// CHECK-NOT: #line
