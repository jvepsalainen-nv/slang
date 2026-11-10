//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A struct that fails to provide a required associated type is rejected with E38100 (missing interface member) naming the missing associated type.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that omitting a required associated type from a conforming struct
// produces E38100. FailsAssoc declares no ElemType; CHECK pins the caret-aligned
// "missing interface member" message and E38100 on the struct declaration line.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

interface IHasAssoc
{
    associatedtype ElemType;
}

struct FailsAssoc : IHasAssoc
//CHECK:            ^^^^^^^^^ missing interface member
//CHECK:            ^^^^^^^^^ type 'FailsAssoc' does not provide required interface member 'ElemType'
{
}

void main() {}
