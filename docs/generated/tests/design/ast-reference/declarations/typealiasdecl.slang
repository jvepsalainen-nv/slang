//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A TypeAliasDecl (`typealias Y = X;`) is the modern alias spelling and is interchangeable with the original type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the modern alias spelling behaves like the typedef spelling:
// the alias and its target are the same type. A local declared with the alias
// is passed to a `float` parameter and the CHECK asserts the scaled result.

//TEST:INTERPRET(filecheck=CHECK):

typealias Velocity = float;

float scale(float v) { return v * 2.0f; }

void main()
{
    Velocity vel = 1.5f;
    //CHECK: 3.000000
    printf("%f\n", scale(vel));
}
