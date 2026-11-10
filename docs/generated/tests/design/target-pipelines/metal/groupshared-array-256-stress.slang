//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#specializeaddressspaceformetal
//META: purpose=Stress: a 256-element `groupshared` array still receives the `threadgroup` address space and emits as `array<int, int(256)> threadgroup*`.
//META: intent=stress
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pushes the address-space assignment at a large array bound to confirm it
// is driven by the variable's storage class rather than by anything that
// scales with element count. CHECK asserts the pointer form
// `array<int, int(256)> threadgroup*` reaches emit, which also pins that
// the array bound survived the array-specialization passes intact.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

groupshared int sarr[256];
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint tid : SV_GroupIndex)
{
    sarr[tid] = int(tid);
    outBuf[tid] = sarr[tid];
}

// CHECK: array<int, int(256)> threadgroup*
