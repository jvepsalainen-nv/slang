//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=An interface declaration appears as let %I : Type = interface(%req...) whose operands are the interface_req_entry value-ids.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies that the requirement entries are reachable from the interface type
// itself rather than floating free: the interface inst lists them as its
// operands. The CHECK pins a two-operand list for a two-requirement interface,
// with the closing parenthesis so a longer list would not match.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IBar
{
    int doA(int x);
    int doB(int x);
};

struct S : IBar
{
    int doA(int x) { return x + 1; }
    int doB(int x) { return x * 2; }
};

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    S s;
    buf[0] = s.doA(inVal) + s.doB(inVal);
}

// CHECK: let  %IBar : Type = interface(%{{[0-9]+}}, %{{[0-9]+}})
