//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=Expansion: wgsl-legalize emits a `@binding(N) @group(N)` pair for every resource in a multi-buffer entry point — two buffers each get their own annotation.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Multi-resource axis on wgsl-legalize: two RWStructuredBuffers each
// receive a distinct `@binding(N)` annotation alongside `@group(N)`
// in the WGSL emit.

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main

uniform RWStructuredBuffer<int> bufA;
uniform RWStructuredBuffer<int> bufB;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bufA[0] = int(tid.x);
    bufB[0] = int(tid.y);
}

// WGSL-DAG: @binding
// WGSL-DAG: @group
// WGSL: @compute
