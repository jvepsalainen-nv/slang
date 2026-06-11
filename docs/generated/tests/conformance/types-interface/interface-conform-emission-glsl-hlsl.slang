//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=A struct conforming to an interface with a method emits to GLSL with the concrete method directly called; interface specialization produces GLSL with the concrete type's method name.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL-target companion for the GLSL conform-emission sibling: fills the
// missing hlsl back-end. An interface-typed parameter specialized for the
// concrete `Tripler` must emit the concrete method `Tripler_process` and the
// specialized free function `applyProc` in HLSL — no virtual dispatch table.

//TEST:SIMPLE(filecheck=EMITHLSL):-target hlsl -entry computeMain -stage compute

interface IProcessor
{
    int process(int x);
}

struct Tripler : IProcessor
{
    int process(int x) { return x * 3; }
}

int applyProc(IProcessor p, int x)
{
    return p.process(x);
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Tripler t;
    outputBuffer[0] = applyProc(t, int(id.x) + 5);
}

// EMITHLSL: Tripler_process
// EMITHLSL: applyProc
