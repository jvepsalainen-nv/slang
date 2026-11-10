//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#witness-and-witness-table-evidence
//META: purpose=Proving T conforms to an interface constructs the conformance evidence an inheritance declaration carries, and that evidence is what permits dispatching the interface's methods on a T value inside a generic.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the consumption side of declared conformance evidence: the
// generic body calls `v.foo()` knowing only `T : IFoo`, so the call can
// resolve only through the evidence the conformer's inheritance clause
// produced. Two conformers are passed through the same generic; CHECK
// asserts each returns its own implementation's value, which shows the
// dispatch followed each type's own evidence.

//TEST:INTERPRET(filecheck=CHECK):

interface IFoo { int foo(); }

struct A : IFoo { int foo() { return 42; } }
struct B : IFoo { int foo() { return 43; } }

int callFoo<T : IFoo>(T v) { return v.foo(); }

void main()
{
    A a;
    B b;
    // CHECK: r=42,43
    printf("r=%d,%d\n", callFoo(a), callFoo(b));
}
