//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#linking-and-validation
//META: purpose=The check-optional-none-usage validation pass rejects an Optional.value read when the value is always `none`.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Reading `.value` of a freshly default-constructed `Optional<int>`
// (which is always `none`) is rejected by the
// `slang-ir-check-optional-none-usage.cpp` pass.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Optional<int> o;
    buf[0] = o.value;
//CHECK:       ^^^^^ accessing .value on an Optional that is always none
// CHECK: E41027
}
