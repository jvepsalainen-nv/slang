//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=The shared SourceWriter emits #line N "<file>" directives in the CUDA C++ text so nvrtc can map errors back to Slang source.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDASourceEmitter inherits from the C-like emitter family that
// shares the `SourceWriter`. The default behavior emits `#line N
// "..."` directives in the output so the downstream compiler can
// report errors against the original source.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: #line {{[0-9]+}} {{.*}}
