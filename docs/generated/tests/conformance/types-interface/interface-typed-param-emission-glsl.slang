//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=When a function with an interface-typed parameter is called with a compile-time-known concrete type, the emitted HLSL is specialized to the concrete type (no virtual dispatch table, no type tag switch).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the typed-param emission sibling: fills the missing
// glsl back-end. `callProcess(IProc, int)` invoked with the concrete `Doubler`
// must be specialized in GLSL, emitting the concrete `Doubler_process` and the
// specialized `callProcess` free function with no virtual dispatch.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute

interface IProc
{
    int process(int x);
}

struct Doubler : IProc
{
    int process(int x) { return x * 2; }
}

int callProcess(IProc p, int x)
{
    return p.process(x);
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Doubler d;
    outputBuffer[0] = callProcess(d, int(id.x) + 7);
}

// EMITGLSL: Doubler_process
// EMITGLSL: callProcess
