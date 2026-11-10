//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-b-specialization-and-type-legalization
//META: purpose=`lowerAppendConsumeStructuredBuffers` fires on Metal (the gate is `target != HLSL`), splitting an `AppendStructuredBuffer<T>` into element and counter pointers with an atomic counter bump.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `target != HLSL` gate really does route Metal through the
// append/consume lowering rather than leaving the buffer type for the
// backend. MSL has no append buffer, so `Append` must become an explicit
// two-part representation. CHECK asserts the entry point gained separate
// `_elements` and `_counter` pointer parameters and that the emitted
// helper bumps the counter with `atomic_fetch_add_explicit` before storing
// the element -- the shape only this pass produces.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

AppendStructuredBuffer<float> appendBuf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    appendBuf.Append(float(tid.x));
    outBuf[tid.x] = 1.0f;
}

// CHECK-DAG: appendBuf_elements_{{[0-9]+}}
// CHECK-DAG: appendBuf_counter_{{[0-9]+}}
// CHECK-DAG: atomic_fetch_add_explicit
// CHECK-NOT: AppendStructuredBuffer<
