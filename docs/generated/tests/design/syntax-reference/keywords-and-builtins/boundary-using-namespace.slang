//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=Boundary: `using` is listed in the decl-keywords table (`parseUsingDecl`); `using namespace N;` brings `N`'s members into the current scope so they may be looked up unqualified.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pairs with `decl-namespace-scope.slang`, which exercises only the
// `::`-qualified form. This test exercises the `using` declaration
// itself.

//TEST:INTERPRET(filecheck=CHECK):

namespace lib { int get() { return 42; } }
using namespace lib;

void main()
{
    int v = get();
    // CHECK: v=42
    printf("v=%d\n", v);
}
