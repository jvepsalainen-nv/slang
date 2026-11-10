//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#top-level-structure
//META: purpose=`NamespaceDecl` accepts a nested chain `IDENT (('.' | '::') IDENT)*` before the brace body.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the nested-namespace chain in a single declaration header,
// once with the '.' separator and once with '::'. Members are then
// reached through the full qualified path, proving each header built
// a two-level namespace chain rather than a single flat name.

//TEST:INTERPRET(filecheck=CHECK):

namespace outer.byDot
{
    int f() { return 40; }
}

namespace outer::byColons
{
    int g() { return 2; }
}

void main()
{
    // CHECK: r=42
    printf("r=%d\n", outer::byDot::f() + outer::byColons::g());
}
