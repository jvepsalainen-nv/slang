//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#stage-specific-entry-point-attributes
//META: doc_section_digest=5332741d22bd1f66cc006924c76c4414130d880c08abe1915fb243255799a71b
//META: purpose=`[numthreads(x,y,z)]` lowers to GLSL `layout(local_size_x=..., local_size_y=..., local_size_z=...)`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out onto WGSL of the `[numthreads]` lowering claim that the sibling
// observes on GLSL. On WGSL the attribute lowers to the `@workgroup_size(...)`
// entry-point attribute; CHECK pins `@workgroup_size(16, 1, 1)`, proving the
// chosen dimensions reach the emitted WGSL compute entry point.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(16, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: @workgroup_size(16, 1, 1)
