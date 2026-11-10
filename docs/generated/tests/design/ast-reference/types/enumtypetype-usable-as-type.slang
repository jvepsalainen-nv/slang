//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=An enum name is usable as a value type; a variable of the enum type holds one of its enumerators and selects the matching switch case.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an enum declaration yields a usable value type: a local
// declared with the enum name holds an enumerator, and switching on it
// picks that enumerator's case. CHECK asserts the marker written by the
// Green case only, so an enum value that decayed to an untyped integer
// or to the first enumerator would be visible.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green, Blue }

void main()
{
    Color c = Color.Green;
    int r = 0;
    switch (c)
    {
    case Color.Red:   r = 1; break;
    case Color.Green: r = 2; break;
    case Color.Blue:  r = 3; break;
    }
    // CHECK: r=2
    printf("r=%d\n", r);
}
