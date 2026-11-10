//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#user-defined-syntax
//META: purpose=A `CapabilityName` in `__require_capability` that is not a known capability atom is reported as an unknown capability.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the rejection half of the RequireCapabilityDecl production:
// the `CapabilityName` slot is an identifier syntactically, but the
// name must resolve to a real capability atom. The caret span covers
// exactly the identifier, so the test also pins that the diagnostic
// blames the capability name rather than the whole declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

__require_capability not_a_capability_atom;
//CHECK:             ^^^^^^^^^^^^^^^^^^^^^ unknown capability
//CHECK:             ^^^^^^^^^^^^^^^^^^^^^ unknown capability name 'not_a_capability_atom'.

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 7;
}
