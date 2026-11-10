//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=A WaveSize attribute on a compute entry point lowers to a waveSize decoration carrying the requested lane count.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the single integer operand of `waveSize`. The CHECK pins
// `[waveSize(32 : Int)]` and then `func %main`, showing the requested lane
// count is recorded on the entry-point function where an execution-mode
// request has to live.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
[WaveSize(32)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [waveSize(32 : Int)]
// CHECK: func %main
