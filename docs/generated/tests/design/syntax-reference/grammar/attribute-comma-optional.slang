//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#attributes-and-decorations
//META: purpose=Several `AttributeBody` items may share one bracket and the separating comma is optional, so `[a b]` parses like `[a, b]`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `(','? AttributeBody)*` repetition. Two attributes are
// packed into a single bracket with no comma between them, and both
// have to take effect: `shader("compute")` is what makes the function
// an entry point at all (the compile is driven without -entry/-stage),
// and `numthreads(2, 1, 1)` has to survive as the group size. Losing
// either one changes the emitted text.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl

RWStructuredBuffer<int> outputBuffer;

// CHECK: numthreads(2, 1, 1)
// CHECK: void computeMain
[shader("compute") numthreads(2, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 1;
}
