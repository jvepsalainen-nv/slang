//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=Inheriting types may override a default method using `override`; emitted code contains the default-impl function for the non-overriding struct and the concrete override function for the overriding struct on every target.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the override emission sibling: fills the missing
// glsl back-end. `DefaultUser` keeps the interface default `compute`, while
// `OverrideUser` overrides it. GLSL must emit the default-impl function (whose
// mangled name carries `defaultImpl`) for the non-overriding path and the
// concrete `OverrideUser_compute` for the overriding path.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute

interface IComputable
{
    int base(int v);
    int compute(int v) { return base(v) + 100; }
}

struct DefaultUser : IComputable
{
    int base(int v) { return v; }
}

struct OverrideUser : IComputable
{
    int base(int v) { return v; }
    override int compute(int v) { return v * 3; }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    DefaultUser du;
    OverrideUser ou;
    outputBuffer[0] = du.compute(int(id.x) + 1);
    outputBuffer[1] = ou.compute(int(id.x) + 1);
}

// EMITGLSL: defaultImpl
// EMITGLSL: OverrideUser_compute
