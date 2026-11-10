//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeemptytypes-runs-twice
//META: purpose=`legalizeEmptyTypes` removes an empty-struct parameter entirely, so the emitted Metal function takes only its non-empty arguments.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that empty aggregate types do not reach the Metal emitter. MSL
// gives an empty struct a non-zero size, so leaving one in a signature
// would change layout and ABI; the legalization instead erases it. The
// helper takes an empty struct plus a live float, and CHECK asserts the
// emitted helper has a single `float` parameter with no `Empty` type
// declared anywhere.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

struct Empty {};

RWStructuredBuffer<float> outBuf;

float use(Empty e, float v) { return v * 2.0f; }

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Empty e;
    outBuf[tid.x] = use(e, float(tid.x));
}

// CHECK: float use_{{[0-9]+}}(float
// CHECK-NOT: struct Empty
