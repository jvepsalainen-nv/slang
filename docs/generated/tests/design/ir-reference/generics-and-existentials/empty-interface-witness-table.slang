//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=A struct conforming to an interface with zero methods emits an empty witness_table (no witness_table_entry rows).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary at zero requirements. The conformance still exists as a table so a
// constrained generic can take it as an argument, but there is nothing to key;
// the CHECK pins the semicolon-terminated form the dump uses for a childless
// witness table.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IEmpty { };
struct E : IEmpty { int payload; };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int useEmpty<T : IEmpty>(T t, int x) { return x; }

[numthreads(1, 1, 1)]
void main()
{
    E e;
    e.payload = inVal;
    buf[0] = useEmpty<E>(e, inVal);
}

// CHECK: witness_table %{{[0-9]+}} : witness_table_t(%IEmpty)(%E);
