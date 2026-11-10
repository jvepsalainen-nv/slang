//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies the int MIN literal -2147483648 is emitted as int(-2147483648) on CUDA so the value is well-formed under nvrtc.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: signed integer MIN literal in CUDA emit. The CUDA
// emitter wraps integer constants in `int(...)` constructor casts so
// negative literals do not lex as unary-minus + unsigned.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = int(-2147483648);
    outBuf[tid.x] = a + int(tid.x);
}

// CHECK: int(-2147483648)
