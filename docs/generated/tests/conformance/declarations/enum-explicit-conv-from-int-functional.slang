//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#enumeration-types
//META: purpose=Values of the tag type can be explicitly converted back to the enumeration type using a constructor-style cast.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an integer can be explicitly converted back to an enum via a constructor cast.
// The tag value of `Color.Green` (3) is round-tripped through `int` then `Color(g)`;
// printing `int(c)` and checking for 3 proves the conversion produces the correct enumerator.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green = 3, Blue }

void main()
{
    int g = Color.Green;
    Color c = Color(g);
    // CHECK: 3
    printf("%d\n", int(c));
}
