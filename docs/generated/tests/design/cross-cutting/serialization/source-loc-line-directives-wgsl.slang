//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:35:46Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/cross-cutting/serialization.md#source-location-serialization
//META: doc_section_digest=a7785d3d0d63d41c707dce8b6259552b48fc0294b3f0028ba5ef1269c5af67e6
//META: purpose=Source locations survive the compile and reappear in emitted text as #line directives on C-family targets and as OpSource/OpLine markers on SPIR-V.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out of the source-location round-trip claim onto WGSL.
// WGSL emit also threads the reconstructed locations through `#line`
// directives; the file-naming form `#line N "<path>"` appears once at the
// top of the module. CHECK pins that directive plus the source path,
// leaving the line number wild.

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute -line-directive-mode standard

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 42;
}

// WGSL: #line {{[0-9]+}} "{{.*source-loc-line-directives-wgsl\.slang}}"
