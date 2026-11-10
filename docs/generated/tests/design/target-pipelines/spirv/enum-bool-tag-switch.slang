//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=A switch on an enum whose tag type is bool takes the same integer-switch rewrite as a plain bool switch.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the enum extension of the bool-switch rewrite: the pass must also
// fire when the selector is an enum whose underlying tag type is bool, not
// only for a literal bool. The enum value is chosen from a buffer load so the
// switch survives to emit; CHECK asserts the bool tag was widened with
// OpSelect %int and that the emitted OpSwitch carries the integer literal 1.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

enum Flag : bool
{
    Off = false,
    On = true,
}

RWStructuredBuffer<int> outBuf;
StructuredBuffer<int> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Flag f = inBuf[tid.x] > 0 ? Flag.On : Flag.Off;
    int r = 0;
    switch (f)
    {
    case Flag.On:
        r = 5;
        break;
    default:
        r = 6;
        break;
    }
    outBuf[tid.x] = r;
}

// CHECK-DAG: OpSelect %int
// CHECK-DAG: OpSwitch %{{[a-zA-Z_0-9]+}} %{{[a-zA-Z_0-9]+}} 1
