//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerimmutablebufferloadforcuda
//META: purpose=Boundary - a struct whose field walk reaches an unrecognized leaf discards the half-built load function and returns empty, so the whole struct load stays an ordinary .Load with no per-field __ldg emitted.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the discard path rather than the outright miss: a struct
// IS a recognized type op, so the pass starts building a per-field
// helper, but one field is a pointer with no __ldg form, and the
// documented behaviour is to throw away the partial helper for the
// whole struct instead of emitting a mixed load. Contrast with the
// all-recognized-fields struct test, which does get a helper. The
// CHECK asserts the struct load emits as a plain .Load and that no
// __ldg or slang_ldg helper was generated at all.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

struct Rec
{
    float* p;
};

StructuredBuffer<Rec> roBuf;
RWStructuredBuffer<float> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Rec r = roBuf[tid.x];
    outputBuffer[tid.x] = *r.p;
}

// CHECK: StructuredBuffer<Rec_{{[0-9]+}}> roBuf_{{[0-9]+}};
// CHECK: *globalParams_{{[0-9]+}}->roBuf_{{[0-9]+}}.Load(
// The partial per-field helper is discarded, not emitted.
// CHECK-NOT: slang_ldg
// CHECK-NOT: __ldg
