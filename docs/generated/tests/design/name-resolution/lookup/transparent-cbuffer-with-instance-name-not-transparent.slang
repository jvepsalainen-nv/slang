//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#transparent-members
//META: purpose=A cbuffer that declares an instance name is not a transparent member: its fields are reachable only through the instance, so an unqualified reference to a field is undefined while the qualified one resolves.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "no instance name" condition on transparent injection.
// `cbuffer C { float a; } c;` takes the named-form branch of the
// parser, so no TransparentModifier is attached and lookup never
// searches inside it from the enclosing scope. The qualified `c.a`
// resolves; the bare `a` falls through every scope and is reported as
// an undefined identifier.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -stage compute -entry main

cbuffer C { float a; } c;

RWStructuredBuffer<float> outBuf;

[numthreads(1,1,1)]
void main()
{
    outBuf[0] = c.a;
    outBuf[1] = a;
//CHECK:        ^ undefined identifier
//CHECK:        ^ undefined identifier 'a'.
// CHECK: E30015
}
