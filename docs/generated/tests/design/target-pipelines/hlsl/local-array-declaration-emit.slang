//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: a local fixed-size array declaration is emitted as `T name[N];` in HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The shared CLikeSourceEmitter writes fixed-size array
// declarations with HLSL-style trailing brackets.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int arr[4];
    arr[0] = int(tid.x);
    arr[1] = int(tid.x) + 1;
    arr[2] = int(tid.x) + 2;
    arr[3] = int(tid.x) + 3;
    outBuf[tid.x] = arr[2];
}

// CHECK: int arr_{{[0-9]+}}[
