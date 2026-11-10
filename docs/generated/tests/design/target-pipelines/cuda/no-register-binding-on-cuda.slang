//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#conditional-gates
//META: purpose=CUDA is not isD3DTarget and is non-Khronos so HLSL register(uN) bindings do not appear in CUDA emit; resources are reached through GlobalParams_0.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The `isCUDATarget(targetRequest)` predicate selects a code path
// that emits resources as struct fields of `GlobalParams_0` in
// `__constant__` memory rather than as HLSL-style
// `register(uN)`-annotated globals.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;
ByteAddressBuffer bab;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(bab.Load<uint>(tid.x * 4));
}

// CHECK: globalParams_{{[0-9]+}}
// CHECK-NOT: register(u
// CHECK-NOT: register(t
