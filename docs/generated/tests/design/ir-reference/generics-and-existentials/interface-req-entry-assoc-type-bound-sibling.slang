//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=An associated-type bound is a sibling interface_req_entry carrying witness_table_t(bound), not an entry nested inside the associated type's own entry.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on how a bound on an associated type is represented. `associatedtype
// A : IBar` produces two peers at the same level: the associated type's own
// entry and a separate entry whose requirement value is `witness_table_t(%IBar)`
// — the conformance every implementer must supply for its chosen `A`. The
// CHECK-DAGs pin both, and the final one fixes the interface's operand list at
// three sibling entries.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IBar { int bar(int x); };
interface IHasAssoc { associatedtype A : IBar; A make(int x); };

struct BarImpl : IBar { int v; int bar(int x) { return v + x; } };
struct S : IHasAssoc
{
    typealias A = BarImpl;
    BarImpl make(int x) { BarImpl b; b.v = x; return b; }
};

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int use<T : IHasAssoc>(T t, int x) { return t.make(x).bar(x); }

[numthreads(1, 1, 1)]
void main()
{
    S s;
    buf[0] = use<S>(s, inVal);
}

// CHECK-DAG: interface_req_entry(%{{[0-9]+}}, witness_table_t(%IBar))
// CHECK-DAG: interface_req_entry(%IHasAssocx5FA, associated_type)
// CHECK-DAG: let  %IHasAssoc : Type = interface(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}})
