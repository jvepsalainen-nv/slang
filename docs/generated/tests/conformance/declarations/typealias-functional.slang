//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#type-aliases
//META: purpose=A `typealias` declaration defines a name that is equivalent to the type on the right of `=`; the alias and the original type are interchangeable.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `typealias` name is interchangeable with the aliased type.
// Variables declared as `Height` and `Width` hold an int and a float respectively;
// CHECK lines assert 180 and 75.5, confirming the aliases resolved to their underlying types.

//TEST:INTERPRET(filecheck=CHECK):

typealias Height = int;
typealias Width = float;

void main()
{
    Height h = 180;
    Width w = 75.5;
    // CHECK: 180
    // CHECK: 75.5
    printf("%d\n%g\n", h, w);
}
