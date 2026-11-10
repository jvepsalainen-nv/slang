//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Boundary: a void entry-point body with no statements emits a syntactically valid `void main(...)` { } in HLSL.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: empty function body. The entry point with no
// statements must still emit a valid signature and a closing
// brace.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
}

// CHECK: void main(
// CHECK: }
