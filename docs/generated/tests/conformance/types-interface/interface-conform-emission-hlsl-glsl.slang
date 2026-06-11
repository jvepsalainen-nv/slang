//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=A struct conforming to an interface with a method and a static const member emits correctly to HLSL: the struct type and method are present, the static const is inlined.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the HLSL conform-emission sibling: fills the
// missing glsl back-end. `Square : IShape` with a method and a static const
// member must emit the concrete method `Square_area` in GLSL, and the
// `static const int dims = 2` must be inlined as the literal `2.0` rather
// than carried as a runtime member load.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute

interface IShape
{
    float area();
    static const int dims;
}

struct Square : IShape
{
    static const int dims = 2;
    float side;
    float area() { return side * side; }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Square sq;
    sq.side = 3.0f;
    outputBuffer[0] = sq.area();
    outputBuffer[1] = float(Square.dims);
}

// EMITGLSL: Square_area
// EMITGLSL: 2.0
