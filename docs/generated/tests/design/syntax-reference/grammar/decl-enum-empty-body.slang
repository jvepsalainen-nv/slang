//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`EnumDecl`'s case list is optional, so an enum may be declared with an empty `{ }` body.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the zero-case boundary of the EnumDecl body, whose case list is
// parenthesised as optional in the production. An enum with no enumerators is
// declared at module scope and the program still runs to completion; printing
// the sentinel proves the empty brace pair was accepted rather than treated as
// a missing case list.

//TEST:INTERPRET(filecheck=CHECK):

enum Empty
{
}

void main()
{
    // CHECK: r=14
    printf("r=14\n");
}
