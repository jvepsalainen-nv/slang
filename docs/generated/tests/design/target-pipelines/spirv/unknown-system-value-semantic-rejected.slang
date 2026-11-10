//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=Negative: a semantic the `SV_*` name-match chain does not recognize falls through to error E49999, so an unrecognized system-value semantic fails the SPIR-V compile inside the entry-point legalization rather than at emit.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fall-through arm of the semantic resolution chain. Every
// recognized SV_* name is mapped to a gl_* builtin identity; a name that
// matches nothing is not silently passed through to the backend but is
// diagnosed while the entry point is being legalized. The caret is anchored
// on the parameter the semantic decorates, which is where the compiler
// reports the span, and the stable code E49999 is pinned rather than the
// message wording.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint bogus : SV_NotARealSemantic)
//CHECK:       ^^^^^ E49999
{
    outBuf[0] = bogus;
}
