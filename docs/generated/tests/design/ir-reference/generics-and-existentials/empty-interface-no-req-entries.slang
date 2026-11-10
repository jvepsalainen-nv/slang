//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=An interface with zero requirements lowers to an interface opcode with no interface_req_entry operands.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary at zero requirements on the interface side. The CHECK matches the
// interface line and the CHECK-NOT asserts no operand list follows it — an
// opening parenthesis would mean at least one requirement entry was attached.
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

// CHECK: let  %IEmpty : Type = interface
// CHECK-NOT: let  %IEmpty : Type = interface(
