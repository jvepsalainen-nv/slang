//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#sibling-scopes
//META: purpose=Each body of a reopened namespace has its own Scope, and the checker attaches the other bodies' scopes as siblings, so code in a later body reaches an earlier body's member unqualified.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Sibling-scope use 3: each `namespace Foo { ... }` body is parsed with its
// own Scope (recorded in NamespaceDecl::lexicalScopes), and
// visitNamespaceDecl wires every body to the others. A call written inside
// the second body therefore finds `first()` from the first body with no
// `Foo::` qualification.

//TEST:INTERPRET(filecheck=CHECK):

namespace Foo {
    int first() { return 40; }
}

namespace Foo {
    int second() { return first() + 2; }
}

void main()
{
    // CHECK: v=42
    printf("v=%d\n", Foo::second());
}
