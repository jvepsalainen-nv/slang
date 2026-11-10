//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeirformetal
//META: purpose=`SV_DispatchThreadID` lowers to a `uint3` kernel parameter carrying Metal's `[[thread_position_in_grid]]` system-value attribute.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the varying-parameter half of `legalizeIRForMetal`: an HLSL
// system-value semantic has no meaning in MSL, so the parameter must be
// re-annotated with the equivalent Metal attribute. CHECK matches the
// parameter declaration and then, on the same emitted line, the
// `thread_position_in_grid` marker -- matched as a bare substring because
// FileCheck would read the literal `[[...]]` form as a variable reference.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: uint3 tid_{{[0-9]+}}
// CHECK-SAME: thread_position_in_grid
