//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A UsingDecl brings names from another scope into the current one so they resolve without qualification.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `using namespace N;` makes `N`'s members reachable
// unqualified. The call in `main` uses the bare name; the CHECK asserts the
// namespaced function's result, so the using declaration must have injected
// the name into the enclosing scope.

//TEST:INTERPRET(filecheck=CHECK):

namespace N { int compute() { return 42; } }

using namespace N;

void main()
{
    //CHECK: 42
    printf("%d\n", compute());
}
