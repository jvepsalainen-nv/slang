//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface `static const` requirement whose type is not `int` or `bool` is rejected with E30306.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `static const` requirement with a type other than `int` or
// `bool` is rejected with E30306. IHasBadStatic uses `float`; CHECK pins the
// caret-aligned "invalid static const requirement type" message and E30306.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl

interface IHasBadStatic
{
    static const float badMember;
//CHECK:               ^^^^^^^^^ invalid static const requirement type
//CHECK:               ^^^^^^^^^ 'static const' requirement can only have int or bool type.
}

void main() {}

// CHECK: E30306
