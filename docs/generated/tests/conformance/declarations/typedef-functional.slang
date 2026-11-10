//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#type-aliases
//META: purpose=The traditional `typedef` syntax also declares a type alias equivalent to the named type.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the C-style `typedef` syntax introduces a type alias equivalent to the named type.
// `Height` is a typedef for `int`; assigning 200 and reading it back as raw `int`
// and checking for 200 proves the alias is transparent.

//TEST:INTERPRET(filecheck=CHECK):

typedef int Height;

void main()
{
    Height h = 200;
    int raw = h;
    // CHECK: 200
    printf("%d\n", raw);
}
