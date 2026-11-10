//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#hlsl
//META: purpose=Named constants are never emitted as raw integers by the HLSL backend: a work-graph `Barrier()` flag set is expanded back into DXC's flag tokens (`UAV_MEMORY`, `ALL_MEMORY`, `GROUP_SYNC`, `DEVICE_SCOPE`, ...) joined with `|`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the flag-set expansion in the HLSL backend. The Slang surface is a
// typed enum, and the naive emission would be the underlying integer; DXC maps
// the token names at parse time, so an integer would silently break if the
// mapping changed. Three calls cover a single flag, a combined flag set, and
// the `ALL_MEMORY` convenience value. CHECK asserts each call site emits the
// token spelling, and CHECK-NOT rules out a bare integer argument surviving.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature

import experimental.workgraph;

[shader("node")]
[NodeLaunch("broadcasting")]
[NodeDispatchGrid(1, 1, 1)]
[numthreads(1, 1, 1)]
void main(RWBuffer<int> buf)
{
    buf[0] = 1;
    Barrier(BarrierMemoryTypeFlags.UAV_MEMORY, BarrierSemanticFlags.GROUP_SYNC);
    Barrier(
        BarrierMemoryTypeFlags.UAV_MEMORY | BarrierMemoryTypeFlags.NODE_OUTPUT_MEMORY,
        BarrierSemanticFlags.GROUP_SCOPE | BarrierSemanticFlags.DEVICE_SCOPE);
    Barrier(BarrierMemoryTypeFlags.ALL_MEMORY, BarrierSemanticFlags.GROUP_SYNC);
}

// HLSL: Barrier((UAV_MEMORY), (GROUP_SYNC));
// HLSL: Barrier((UAV_MEMORY | NODE_OUTPUT_MEMORY), (GROUP_SCOPE | DEVICE_SCOPE));
// HLSL: Barrier((ALL_MEMORY), (GROUP_SYNC));
// HLSL-NOT: Barrier((1)
