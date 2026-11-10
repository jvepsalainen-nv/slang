//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#attributes-and-decorations
//META: purpose=`Attribute` also accepts the C++-style double-bracket spelling `'[[' AttributeBody ']]'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the double-bracket alternative of the Attribute production
// carries the same meaning as the single-bracket form: the thread-group
// size written as `[[numthreads(2, 1, 1)]]` has to reach the emitted
// HLSL as `[numthreads(2, 1, 1)]`. Checking the argument values (not
// just the attribute name) is what rules out the brackets being parsed
// as an empty attribute plus a stray token.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry computeMain

RWStructuredBuffer<int> outputBuffer;

// CHECK: numthreads(2, 1, 1)
[[numthreads(2, 1, 1)]]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outputBuffer[0] = int(tid.x);
}
