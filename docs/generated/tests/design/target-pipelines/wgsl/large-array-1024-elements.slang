//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=A 1024-element function-local int array emits as array<i32, i32(1024)> with the size preserved verbatim
//META: intent=stress
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress probe of the function-local fixed-size-array emit path
// with a large element count; the size literal flows through into
// the array<T, N> spelling.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int arr[1024];
    for (int i = 0; i < 1024; ++i) arr[i] = i;
    outBuf[tid.x] = arr[1023];
}

// CHECK: array<i32, i32(1024)>
