//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A property requirement in an interface may alternatively be satisfied by declaring a compatible variable with a matching name in the conforming struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a plain struct field with the same name satisfies a property
// requirement. StructWithField declares `float myVal` rather than explicit
// accessors; CHECK asserts the assigned value 3.5 is readable, confirming the
// field was accepted as the conformance witness for the property.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasFloat
{
    property myVal : float
    {
        get;
        set;
    }
}

struct StructWithField : IHasFloat
{
    // Plain field satisfies the property requirement
    float myVal;
}

void main()
{
    StructWithField s;
    s.myVal = 3.5f;
    //CHECK: myVal=3.5
    printf("myVal=%.1f\n", s.myVal);
}
