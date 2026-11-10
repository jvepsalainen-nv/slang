//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#decl-declbase
//META: purpose=Every Decl carries a name and a parent ContainerDecl, so the same simple name declared in two different parents stays distinguishable at a member-access site.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a Decl records both its name and the container it was
// declared in. Two structs each declare a method spelled `tag`; the
// member-access sites `a.tag()` and `b.tag()` must reach different
// declarations. CHECK asserts the two distinct return values, which is
// only possible if each `tag` decl is keyed by its parent as well as
// by its name.

//TEST:INTERPRET(filecheck=CHECK):

struct A { int tag() { return 7;  } };
struct B { int tag() { return 99; } };

void main()
{
    A a;
    B b;
    //CHECK: a.tag=7
    printf("a.tag=%d\n", a.tag());
    //CHECK: b.tag=99
    printf("b.tag=%d\n", b.tag());
}
