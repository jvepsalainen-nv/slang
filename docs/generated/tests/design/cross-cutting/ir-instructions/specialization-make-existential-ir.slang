//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#specialization-and-existentials
//META: purpose=Assigning a concrete conformer to an interface-typed location lowers to a `makeExistential` IR opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `makeExistential`/`MakeExistential` row ("Packs a
// value plus its witness"). Storing a concrete `A` into an `IFoo`-typed
// local packs the value with its witness table, which lowers to
// `makeExistential(%value, %witness)` in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IFoo { int getVal(); }
struct A : IFoo { int x; int getVal() { return x; } }

int useExistential(IFoo obj) { return obj.getVal(); }

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    A a;
    a.x = 9;
    buf[0] = useExistential(a);
}

// IR: makeExistential(%{{.*}}, %{{.*}})
