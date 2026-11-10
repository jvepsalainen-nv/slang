//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#enumeration-types
//META: purpose=A value of an enumeration type can be implicitly converted to a value of its tag type.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that enum values implicitly convert to their tag type (int) without an explicit cast.
// Assigning `Color.Red` and `Color.Green` directly to `int` variables and printing them
// proves the implicit conversion yields the correct tag values 0 and 3.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green = 3, Blue }

void main()
{
    int r = Color.Red;
    int g = Color.Green;
    // CHECK: 0
    // CHECK: 3
    printf("%d\n%d\n", r, g);
}
