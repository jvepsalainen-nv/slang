//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#type-expression-family-pointertypeexpr-functypeexpr-tupletypeexpr-andtypeexpr-modifiedtypeexpr-packbranchtypeexpr
//META: purpose=A ModifiedTypeExpr `const T` carries a modifier prefix on the type; reads of the const-qualified value return the initialized value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a modifier prefix on a type spelling is accepted and the
// declared value still reads back. `const int` is declared and initialised,
// and the CHECK asserts the initialiser's value survived the modified type
// spelling.

//TEST:INTERPRET(filecheck=CHECK):

static const int kK = 42;

void main()
{
    // CHECK: k=42
    printf("k=%d\n", kK);
}
