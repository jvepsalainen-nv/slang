//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#wgslsourceemitter-policy-overrides-and-bool-conditioned-values
//META: purpose=shouldEmitSwitchCaseTerminatingBreak returns false for WGSL so the trailing break Slang places at the end of every switch case is omitted
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the WGSL emitter policy override that drops the redundant
// terminating `break` Slang normally appends to each switch case: reaching
// the end of a WGSL case already exits the switch, and older validators
// reject a `break` outside a loop. Every case below ends with an explicit
// `break` in the Slang source, so if the override were not honored the
// emitted text would contain the keyword. CHECK asserts the switch is
// emitted and CHECK-NOT asserts no `break` survives anywhere in the output.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = 0;
    switch (int(tid.x))
    {
    case 0: v = 10; break;
    case 1: v = 20; break;
    default: v = 30; break;
    }
    outBuf[tid.x] = v;
}

// CHECK: switch(
// CHECK-NOT: break
