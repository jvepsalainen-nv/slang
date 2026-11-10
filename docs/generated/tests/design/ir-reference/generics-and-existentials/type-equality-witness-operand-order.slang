//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#typeequalitywitness
//META: purpose=A constraint discharged by a type-equality fact lowers to TypeEqualityWitness(subType, superType) typed witness_table_t of that type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the witness form used when a constraint is satisfied by two types
// being equal rather than by an interface implementation. The `where T.A ==
// int` clause is discharged for `T = S` because `S.A` is `int`, so the witness
// is an equality fact; the CHECK pins its two type operands and its
// `witness_table_t(Int)` result type.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IHasA { associatedtype A; A get(); };
struct S : IHasA { typealias A = int; int get() { return 7; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int use<T : IHasA>(T t, int x) where T.A == int { return t.get() + x; }

[numthreads(1, 1, 1)]
void main()
{
    S s;
    buf[0] = use<S>(s, inVal);
}

// CHECK: let  %{{[0-9]+}} : witness_table_t(Int) = TypeEqualityWitness(Int, Int)
