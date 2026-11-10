//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#c
//META: purpose=The C++ backend emits C++ source paired with `slang-cpp-prelude.h` and exports the compute entry point through `SLANG_PRELUDE_EXPORT` shims.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the C++ backend emits code that depends on the shipped C++ prelude
// and that the kernel is reachable from a host. CHECK asserts the prelude
// include (matched by filename because the emitted path is absolute and
// machine-specific), the prelude-provided `RWStructuredBuffer` template used
// for the global-parameter field, and the exported per-thread and per-group
// dispatch shims a host runtime calls.

//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float(tid.x) * 0.5f;
}

// CPP: slang-cpp-prelude.h
// CPP-DAG: RWStructuredBuffer<float> outBuf_{{[0-9]+}};
// CPP-DAG: SLANG_PRELUDE_EXPORT
// CPP-DAG: void main_{{[0-9]+}}_Thread(ComputeThreadVaryingInput*
// CPP-DAG: void main_{{[0-9]+}}_Group(ComputeVaryingInput*
