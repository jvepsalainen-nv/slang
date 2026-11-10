//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#diagnosticsink
//META: purpose=The sink's per-source warning-state tracking lets `#pragma warning(disable: 41024)` suppress that warning for the tokens that follow.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the sink's per-source warning-state tracking: `#pragma
// warning(disable: 41024)` adjusts the enforced severity for the tokens that
// follow it. The same comma-operator expression that warns without the pragma
// is compiled with it; CHECK-NOT asserts neither the code nor the message
// appears, while CHECK asserts the entry point was still emitted.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

#pragma warning(disable: 41024)

RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int x = (1, 2);
    buf[0] = x;
}

// CHECK-NOT: 41024
// CHECK-NOT: comma operator
// CHECK: void main
