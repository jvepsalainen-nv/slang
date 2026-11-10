//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=A generic with two interface constraints lowers to specialize(%base, T, %w1, %w2) — one witness operand per constraint.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on witness-operand multiplicity: a type parameter carrying two
// `where` constraints contributes one witness argument each. The CHECK pins a
// four-element argument list (base, type, witness, witness), so dropping or
// merging either conformance would fail it.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
interface IBar { int meta(); };

struct S : IFoo, IBar
{
    int run(int x) { return x + 1; }
    int meta() { return 42; }
};

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int helper<T>(T t, int x) where T : IFoo where T : IBar
{
    return t.run(x) + t.meta();
}

[numthreads(1, 1, 1)]
void main()
{
    S s;
    buf[0] = helper<S>(s, inVal);
}

// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, %S, %{{[0-9]+}}, %{{[0-9]+}})
