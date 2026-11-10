//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=Negative: the Metal source emitter writes no target-identification header comment; the first emitted text is the `#include` block.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Structural negative observation about the Metal prelude: unlike the
// SPIR-V assembly writer, `MetalSourceEmitter` prepends no `; SPIR-V` /
// `; Version` style banner, so tests and downstream tools can rely on the
// first non-blank line being a preprocessor directive. CHECK anchors on
// the first include and then asserts neither banner token appears anywhere
// in the output.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: #include <metal_stdlib>
// CHECK-NOT: SPIR-V
// CHECK-NOT: ; Version
