//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=Boundary: a shader with zero module-scope uniforms does not produce a `GlobalParams` aggregate in the HLSL emit — the collect-global-uniforms pass has nothing to pack.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Zero-uniform edge of the collect-global-uniforms pass. Only an
// `RWStructuredBuffer` is referenced; no scalar / vector uniform is
// declared, so no `GlobalParams` aggregate is built or emitted.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// HLSL: void main
// HLSL-NOT: GlobalParams
// HLSL-NOT: globalParams
