//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An InterfaceDecl with zero methods lowers to an `IRInterfaceType` carrying no method requirement entries — the witness table for a conforming type still exists but is empty.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: interface-method-count lower edge (zero methods). The
// doc claim is "InterfaceDecl → IRInterfaceType plus per-method
// requirement insts"; at zero methods, the interface still lowers
// to an `interface` instruction but has no
// `interface_req_entry(...)` rows attached.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IEmpty { }
struct A : IEmpty { int v; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

int use<T : IEmpty>(T t) { return 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    A inst;
    inst.v = a;
    buf[0] = use<A>(inst);
}

// CHECK: let  %IEmpty	: Type	= interface
// CHECK: witness_table %{{.*}} : witness_table_t(%IEmpty)(%A)
