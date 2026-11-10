//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#standard-modules
//META: purpose=The neural standard module is declared [ExperimentalModule], so import slang.neural is refused unless experimental features are enabled.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the neural standard module is both discoverable by its
// qualified import path and gated by the [ExperimentalModule]
// attribute its module declaration carries. Compiling without the
// experimental opt-in produces E00104 naming the resolved module path
// 'slang/neural' — the path proves the qualified name was mapped to
// the shipped subdirectory, and the code proves the attribute was
// honoured rather than the module simply being missing.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute

import slang.neural;
/*CHECK:
       ^^^^^ 'slang/neural' is an experimental module, need to enable '-experimental-feature' to load this module
*/

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 0;
}
