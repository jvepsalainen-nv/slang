//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#requirementdecl-style-nodes-inside-interfacedecl
//META: purpose=An interface requirement is whatever declaration was written inside the interface body; a conforming type that omits a required member is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that every declaration in an interface body is a requirement a
// conformer must satisfy. The struct declares a field but not the required
// method, so its conformance must fail; the CHECK pins the
// requirement-not-satisfied error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IShape { int area(); }

struct NotAShape : IShape
{
    int side;
//CHECK: error
//CHECK: E38100
}

void main() {}
