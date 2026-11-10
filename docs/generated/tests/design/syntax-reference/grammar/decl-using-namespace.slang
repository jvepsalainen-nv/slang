//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#top-level-structure
//META: purpose=`UsingDecl` parses as `'using' 'namespace'? Expr ';'`, with the optional `namespace` keyword accepted.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `using namespace N;` spelling of UsingDecl. After the
// directive, a function declared inside the namespace is callable
// without qualification, which requires the whole decl (including the
// optional `namespace` keyword) to have parsed.

//TEST:INTERPRET(filecheck=CHECK):

namespace util
{
    int helper() { return 42; }
}

using namespace util;

void main()
{
    // CHECK: r=42
    printf("r=%d\n", helper());
}
