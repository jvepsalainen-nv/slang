//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#subtype-witnesses
//META: purpose=Declared conformance evidence is reported by an in-scope declaration, which may be a where-clause constraint rather than an inheritance clause, and either spelling permits the same interface dispatch.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second declaration form the evidence can come from. The
// constraint is written as a trailing `where T : IFoo` instead of in
// the type-parameter list, and the body still calls the interface
// method. The same two conformers are passed through both spellings;
// CHECK asserts the where-clause generic returns the same results as
// the inline-constraint generic, so both declaration forms supply
// usable evidence.

//TEST:INTERPRET(filecheck=CHECK):

interface IFoo { int foo(); }

struct A : IFoo { int foo() { return 11; } }
struct B : IFoo { int foo() { return 22; } }

int viaWhere<T>(T v) where T : IFoo { return v.foo(); }
int viaInline<T : IFoo>(T v) { return v.foo(); }

void main()
{
    A a;
    B b;
    // CHECK: where=11,22
    printf("where=%d,%d\n", viaWhere(a), viaWhere(b));
    // CHECK: inline=11,22
    printf("inline=%d,%d\n", viaInline(a), viaInline(b));
}
