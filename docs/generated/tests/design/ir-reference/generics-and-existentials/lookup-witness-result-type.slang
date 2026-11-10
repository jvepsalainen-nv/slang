//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-lookup
//META: purpose=The result type of lookupWitness is the requirement's function type, including the receiver as the second parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies what a witness lookup *evaluates to*: not the value found, but a
// value typed as the requirement's function type. The CHECK reads the `let`
// binding's declared type and asserts it is `Func(Int, %T, Int)` — return
// type, the still-abstract receiver type parameter, then the declared
// parameter.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
struct A : IFoo { int run(int x) { return x + 1; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int helper<T : IFoo>(T t, int x) { return t.run(x); }

[numthreads(1, 1, 1)]
void main()
{
    A a;
    buf[0] = helper<A>(a, inVal);
}

// CHECK: let  %{{[0-9]+}} : Func(Int, %T{{[A-Za-z0-9_]*}}, Int) = lookupWitness(
