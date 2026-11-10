//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`EnumDecl` accepts an optional `'class'` keyword after `'enum'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the optional `'class'` token in the EnumDecl production. The
// enumerators are still reached through the type name and still carry their
// implicit ordinals, so converting `Color.Green` and printing 1 proves the
// `enum class` spelling produced an ordinary enum declaration rather than
// dispatching to the struct/class parser.

//TEST:INTERPRET(filecheck=CHECK):

enum class Color
{
    Red,
    Green
}

void main()
{
    // CHECK: r=1
    printf("r=%d\n", int(Color.Green));
}
