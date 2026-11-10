//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#witnesstableentry-vs-interfacereqentry
//META: purpose=The requirementKey operand of an interface_req_entry is the same key value that names the requirement on the witness_table_entry satisfying it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the declaring side and the satisfying side are joined by inst
// identity rather than by name or by position. The ordered CHECKs require the
// literal same `%IFoox5Frun` value to appear as the first operand of the
// interface's requirement entry and of the conformance's witness-table entry.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

interface IFoo
{
    int run(int x);
}

struct A : IFoo
{
    int run(int x) { return x + 1; }
}

[numthreads(1, 1, 1)]
void main()
{
    A a;
    buf[0] = a.run(inVal);
}

// CHECK: interface_req_entry(%IFoox5Frun,
// CHECK: witness_table_entry(%IFoox5Frun,
