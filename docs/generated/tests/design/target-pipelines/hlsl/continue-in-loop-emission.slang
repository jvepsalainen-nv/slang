//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: a Slang `continue` inside a for-loop is emitted as a recognisable continue-equivalent in HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The IR `continue` is lowered to a branch to the loop's
// continue-block; the emitter renders a structured HLSL loop
// with an `if` filter so the unfiltered iterations skip.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int acc = 0;
    for (int i = 0; i < 6; i = i + 1)
    {
        if (i == 3) continue;
        acc = acc + i;
    }
    outBuf[tid.x] = acc;
}

// CHECK: for(
// CHECK: if(
