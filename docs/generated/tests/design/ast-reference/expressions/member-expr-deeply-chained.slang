//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=Stresses MemberExpr chaining: a five-deep `a.b.c.d.e.v` field access must resolve and read the written value.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// MemberExpr chains build a tree where each `.b` is a MemberExpr
// whose base is the previous MemberExpr. Five nested struct levels
// produce a chain of five MemberExpr nodes; the checker must resolve
// each level and the resulting load must yield the assigned value.

//TEST:INTERPRET(filecheck=CHECK):

struct E { int v; }
struct D { E e; }
struct C { D d; }
struct B { C c; }
struct A { B b; }

void main()
{
    A a;
    a.b.c.d.e.v = 42;
    // CHECK: v=42
    printf("v=%d\n", a.b.c.d.e.v);
}
