//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#standard-modules
//META: purpose=The numerics standard module carries [ExperimentalModule] like all four standard modules, so import slang.numerics is refused with E00104 unless experimental features are enabled.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says all four standard modules carry [ExperimentalModule] and
// that importing one without experimental features fails with E00104
// naming the resolved module path. This pins that for numerics, whose
// public entry point lands in slang/numerics.slang-module.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute

import slang.numerics;
/*CHECK:
       ^^^^^ 'slang/numerics' is an experimental module, need to enable '-experimental-feature' to load this module
*/

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 0;
}
