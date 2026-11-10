//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/overview.md#emit
//META: purpose=`-target torch` on an ordinary compute entry point that takes a parameter, such as an SV_DispatchThreadID, has nothing to bind and produces an empty pybind module rather than crashing.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Same claim as torch-ordinary-entry-has-nothing-to-bind, with the common
// `SV_DispatchThreadID` parameter. The doc says the unmarked entry point is
// simply not bound; the compiler instead segfaults (exit 139), see
// _meta/findings/torch-ordinary-entry-param-sigsegv.yaml.

//TEST:SIMPLE(filecheck=TORCH):-target torch -line-directive-mode none

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    gOut[0] = int(tid.x);
}

// TORCH: PYBIND11_MODULE(TORCH_EXTENSION_NAME, m) {
// TORCH-NEXT: }
// TORCH-NOT: computeMain
