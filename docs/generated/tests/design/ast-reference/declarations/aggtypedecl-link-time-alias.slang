//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: purpose=The link-time alias spelling `struct FooAlias : IFoo = Foo;` makes the alias name usable as a conforming type whose interface methods dispatch to the aliased type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the link-time alias form an aggregate declaration accepts on its
// right-hand side. `FooAlias` is declared with `: IFoo = Foo`; a value of the
// alias type is created and its interface method is called. The CHECK asserts
// the value `Foo::get` returns, proving the alias resolved to `Foo` rather
// than to an empty placeholder type.

//TEST:INTERPRET(filecheck=CHECK):

interface IFoo { int get(); }

struct Foo : IFoo { int get() { return 41; } }

struct FooAlias : IFoo = Foo;

void main()
{
    FooAlias f;
    //CHECK: 41
    printf("%d\n", f.get());
}
