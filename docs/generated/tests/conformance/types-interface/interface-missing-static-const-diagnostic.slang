//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A struct that fails to provide a required `static const int` data member is rejected with E38100 naming the missing member.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that omitting a required `static const int` member from a conforming
// struct fires E38100. FailsStatic supplies no `width`; CHECK pins the
// caret-aligned "missing interface member" message on the struct declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

interface IHasStatic
{
    static const int width;
}

struct FailsStatic : IHasStatic
//CHECK:             ^^^^^^^^^^ missing interface member
//CHECK:             ^^^^^^^^^^ type 'FailsStatic' does not provide required interface member 'width'
{
}

void main() {}
