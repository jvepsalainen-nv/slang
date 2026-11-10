//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may require `static const int` data members; the conforming struct provides one with the same name and type and the doc constraint that the type must be `int` or `bool`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that interface `static const` requirements with `int` and `bool`
// types are satisfiable. ConcreteWithConstants provides both members; CHECK
// asserts the concrete values are readable as intConst=10 and boolConst=1,
// confirming both types are accepted and the values propagate correctly.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasConstants
{
    static const int intConst;
    static const bool boolConst;
}

struct ConcreteWithConstants : IHasConstants
{
    static const int intConst = 10;
    static const bool boolConst = true;
}

void main()
{
    //CHECK: intConst=10 boolConst=1
    printf("intConst=%d boolConst=%d\n",
        ConcreteWithConstants.intConst,
        ConcreteWithConstants.boolConst ? 1 : 0);
}
