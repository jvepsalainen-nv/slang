//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=A generic parameterized interface specialized to a concrete type argument emits the concrete method name on every target; the generic type parameter is resolved at compile time with no polymorphic dispatch residue.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the generic-specialization emission sibling: fills
// the missing glsl back-end. `TestClass : ITypedReq<int>` must specialize the
// generic interface fully, emitting the concrete `TestClass_someFunc` in GLSL
// with no witness-table dispatch residue.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry computeMain -stage compute

interface ITypedReq<T>
{
    T someFunc(T param);
}

struct TestClass : ITypedReq<int>
{
    int someFunc(int param)
    {
        return 123 + param;
    }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    TestClass obj;
    outputBuffer[0] = obj.someFunc(int(id.x) + 7);
}

// EMITGLSL: TestClass_someFunc
