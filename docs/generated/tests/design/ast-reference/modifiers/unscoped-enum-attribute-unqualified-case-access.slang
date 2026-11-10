//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[UnscopedEnum]` written by the user on a plain enum makes its cases resolvable without qualification.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the attribute's scoping consequence: the enum's cases become
// visible in the enclosing scope. `Red` and `Blue` are named without the
// `Color.` prefix, and CHECK asserts each printed value matches its case, which
// proves the bare names bound to the right cases rather than merely compiling.

//TEST:INTERPRET(filecheck=CHECK):

[UnscopedEnum]
enum Color
{
    Red = 7,
    Blue = 42,
}

void main()
{
    //CHECK: red=7 blue=42
    printf("red=%d blue=%d\n", int(Red), int(Blue));
}
