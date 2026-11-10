//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#linkage-and-lifetime
//META: purpose=Boundary - a witness table for an interface-conforming struct carries an export decoration whose mangled name uses the witness-table prefix _SW.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fourth symbol-kind namespace of the export mangled name.
// Assigning a `Mul2` value to an `IDoubler` existential forces the
// conformance witness table to be lowered and exported; the CHECK pins the
// `_SW` prefix, which is what distinguishes a witness-table export from the
// function (`_SR`), type (`_ST`) and variable (`_SV`) forms the sibling
// tests pin.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IDoubler { int doubled(int x); }

struct Mul2 : IDoubler
{
    int doubled(int x) { return x * 2; }
}

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Mul2 m;
    IDoubler d = m;
    buf[0] = d.doubled(int(tid.x));
}

// CHECK: [export("_SW{{.*}}")]
