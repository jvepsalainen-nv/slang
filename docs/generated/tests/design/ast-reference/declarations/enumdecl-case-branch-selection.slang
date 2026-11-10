//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#enumdecl-and-enumcasedecl
//META: purpose=An EnumDecl's cases are distinct named values that select distinct branches when compared.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that each enum case is an independently comparable value. A helper
// compares its argument against every case and returns a distinct number; the
// CHECK asserts all three results, which requires all three cases to compare
// distinctly rather than collapsing.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red = 1, Green = 2, Blue = 3 }

int describe(Color c)
{
    if (c == Color::Red)   return 10;
    if (c == Color::Green) return 20;
    return 30;
}

void main()
{
    //CHECK: 10 20 30
    printf("%d %d %d\n",
        describe(Color::Red),
        describe(Color::Green),
        describe(Color::Blue));
}
