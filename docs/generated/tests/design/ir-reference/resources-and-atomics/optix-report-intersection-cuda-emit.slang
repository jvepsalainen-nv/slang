//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#raytracing-payload
//META: purpose=On `-target cuda`, `ReportHit` in an intersection shader is lowered through `reportOptiXIntersection` and emitted as `optixReportIntersection(tHit, hitKind, a0..aN)` with the attribute aggregate flattened to its scalar leaves.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The two-float attribute struct must appear as two scalar operands after
// tHit and hitKind, which is what the legalization pass produces.

//TEST:SIMPLE(filecheck=CUDA):-target cuda -stage intersection -entry isect

struct Attr
{
    float2 uv;
};

[shader("intersection")]
void isect()
{
    Attr a;
    a.uv = float2(0.25, 0.5);
    ReportHit(1.0, 0, a);
}

// CUDA: optixReportIntersection(1.0f, 0U, {{.*}}uv{{.*}}, {{.*}}uv{{.*}})
