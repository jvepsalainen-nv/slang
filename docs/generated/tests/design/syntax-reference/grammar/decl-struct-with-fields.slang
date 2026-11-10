//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`StructMember` accepts `VarDecl` members produced by `Type IDENT` C-style declarators.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `StructDecl` body parses two `VarDecl` members in
// C-style spelling (`Type IDENT ';'`). The field values are observed
// after construction to prove the declarators bound names.

//TEST:INTERPRET(filecheck=CHECK):

struct Pair { int a; int b; }

void main()
{
    Pair p;
    p.a = 3;
    p.b = 4;
    // CHECK: 3,4
    printf("%d,%d\n", p.a, p.b);
}
