//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#compiler-dictionary-and-late-capability-requirements
//META: purpose=A `__requireCapability(...)` statement also emits a `LateRequireCapability` inst whose single operand is the encoded capability set.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second inst that a capability requirement lowers to: the
// deferred check itself, carried as `LateRequireCapability(<capability set>)`
// inside the function body rather than as a decoration. The CHECK anchors at
// the entry point so the match comes from the user function, and asserts the
// inst takes exactly one `%`-named operand — the set built by the capability
// encoding above it.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    __requireCapability(spirv_1_3);
    outputBuffer[0] = 2;
}

// IR-LABEL: func %main
// IR: LateRequireCapability(%{{[A-Za-z0-9_]+}})
