//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#namespacedecl-moduledecl-filedecl
//META: purpose=A qualified namespace name (`namespace A.B`, `namespace A::B`) is expanded into nested namespaces, so members are reachable through the qualified path.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both qualified-name spellings declare nested namespaces. Functions
// are declared under `namespace A.B` and `namespace C::D` and called through
// `A::B::` and `C::D::`; CHECK asserts the sum, reachable only if the
// qualified names were expanded into nested namespaces.

//TEST:INTERPRET(filecheck=CHECK):

namespace A.B
{
    int f() { return 3; }
}

namespace C::D
{
    int g() { return 4; }
}

void main()
{
    //CHECK: v=7
    printf("v=%d\n", A::B::f() + C::D::g());
}
