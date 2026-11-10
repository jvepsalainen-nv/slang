//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: a Slang while-loop is emitted as an HLSL loop with a header conditional branch by the shared C-like emitter.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The shared CLikeSourceEmitter walks the IR loop and produces
// HLSL loop syntax. After phi elimination the loop body uses
// explicit assignments.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int i = 0;
    int acc = 0;
    while (i < int(tid.x) + 4)
    {
        acc = acc + i;
        i = i + 1;
    }
    outBuf[tid.x] = acc;
}

// CHECK: for(
