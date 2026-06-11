//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#hlsl-semantics-sv
//META: doc_section_digest=c0d08afc8ccd44fdbb2133509498b8edd2e9e1df38204624893050548106177b
//META: purpose=`: register(...)` binding semantic propagates to emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `: register(u3)` binding claim onto GLSL. The register index
// maps to the GLSL buffer binding; CHECK pins `binding = 3`, proving the
// register's slot reaches the emitted GLSL layout for this target.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage compute

RWStructuredBuffer<int> outBuf : register(u3);

[numthreads(1,1,1)]
void main()
{
    outBuf[0] = 1;
}

//CHECK: binding = 3
