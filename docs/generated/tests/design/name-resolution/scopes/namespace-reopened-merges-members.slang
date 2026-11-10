//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#sibling-scopes
//META: purpose=Re-opening the same namespace name reuses the existing NamespaceDecl and links siblings; members from both declarations are reachable via the same qualified name.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// "Multiple `namespace Foo {}` declarations of the same logical
// namespace" is sibling-scope use case 3 in the doc. A second
// `namespace Foo` re-uses the first NamespaceDecl; both members are
// reachable through the same `Foo::` qualification.

//TEST:INTERPRET(filecheck=CHECK):

namespace Foo {
    int a() { return 1; }
}

namespace Foo {
    int b() { return 2; }
}

void main()
{
    int s = Foo::a() + Foo::b();
    // CHECK: s=3
    printf("s=%d\n", s);
}
