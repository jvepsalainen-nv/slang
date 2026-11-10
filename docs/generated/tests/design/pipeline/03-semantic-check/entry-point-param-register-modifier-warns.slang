//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=A `register()` binding on an entry-point parameter is reported as an unsupported-and-ignored modifier (E38010) rather than silently dropped.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the unconditional half of the ignored-binding-modifier check.
// Slang drops `register()` in this position, so the check exists to say so out
// loud instead of letting the user believe the binding took effect. CHECK
// pins E38010 and the message naming the keyword.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK): -target hlsl

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uniform RWStructuredBuffer<int> buf: register(u3))
//CHECK: E38010
//CHECK: keyword 'register' on parameter 'buf'
{
    buf[0] = 1;
}
