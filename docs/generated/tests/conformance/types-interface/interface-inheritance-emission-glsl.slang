//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=A struct conforming to a child interface that inherits from a parent interface emits both parent and child method functions on every target; all requirements from both interfaces are compiled into concrete implementations.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the inheritance emission sibling: fills the missing
// glsl back-end. `Impl : IDerived : IBase` must emit concrete functions for the
// requirements from both interfaces — `Impl_getA` (IBase) and `Impl_getB`
// (IDerived) — in GLSL.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute

interface IBase
{
    int getA();
}

interface IDerived : IBase
{
    int getB();
}

struct Impl : IDerived
{
    int _a;
    int _b;
    int getA() { return _a; }
    int getB() { return _b; }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    Impl obj;
    obj._a = int(id.x) + 10;
    obj._b = int(id.y) + 20;
    outputBuffer[0] = obj.getA();
    outputBuffer[1] = obj.getB();
}

// EMITGLSL: Impl_getA
// EMITGLSL: Impl_getB
