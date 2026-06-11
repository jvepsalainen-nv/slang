//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:13:56+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/types-interface.md#interface-conforming-variants
//META: doc_section_digest=2ed61530bd334a97114c08a34024c5fb9ccf09620d7a60bd6a64f9d345223014
//META: purpose=A variable declared with an interface type is an interface-conforming variant; it may hold any conforming type and member functions are callable on it.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL-target companion for the interface-variant declaration sibling: fills a
// missing glsl back-end. Two distinct conforming concrete types are used as
// locals in the same entry point; GLSL must emit both concrete struct names so
// their methods can be called directly on each variant.

//TEST:SIMPLE(filecheck=EMITGLSL):-target glsl -entry main -stage compute

interface IBase
{
    int getA();
    static const int8_t bias;
}

interface ITest : IBase
{
    int someFunc()
    {
        return getA() + bias;
    }

    static int getUnderlyingWidth();
}

struct ConcreteInt32 : ITest
{
    static const int8_t bias = 3;
    int32_t a;

    int32_t getA() { return a; }
    static int getUnderlyingWidth() { return 32; }
}

struct ConcreteInt16 : ITest
{
    static const int8_t bias = 1;
    int16_t a;

    int getA() { return int(a); }
    override int someFunc() { return int(a) + 5; }
    static int getUnderlyingWidth() { return 16; }
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(RWStructuredBuffer<int> outputBuffer, uint3 id : SV_DispatchThreadID)
{
    if ((id.x & 1) == 1)
    {
        ConcreteInt32 val;
        val.a = int(id.y);
        outputBuffer[id.x] = val.getA() * val.getA();
    }
    else
    {
        ConcreteInt16 val;
        val.a = int16_t(id.y);
        outputBuffer[id.x] = val.getA() * val.getA();
    }
}

// EMITGLSL: ConcreteInt32
// EMITGLSL: ConcreteInt16
