//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#assoctypedecl
//META: purpose=A `where`-clause bound on an associated type (`associatedtype A where A : IBar`) produces the same constraint as the inheritance-style spelling.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `where` spelling of an associated-type bound is
// interchangeable with the `: IBar` spelling. The interface here differs from
// its sibling test only in the bound's spelling; the same generic body calls
// the bound interface's member, and the CHECK asserts the same result, so the
// two spellings must produce the same constraint.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar { int bar(); }

struct Impl : IBar { int bar() { return 9; } }

interface IMakes
{
    associatedtype A where A : IBar;
    A make();
}

struct S : IMakes
{
    typealias A = Impl;
    A make() { A a; return a; }
}

int useMake<T : IMakes>(T t) { return t.make().bar(); }

void main()
{
    S s;
    //CHECK: 9
    printf("%d\n", useMake(s));
}
