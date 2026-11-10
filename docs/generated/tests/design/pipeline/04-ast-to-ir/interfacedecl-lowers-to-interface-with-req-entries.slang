//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An InterfaceDecl lowers to an `IRInterfaceType` whose per-method `interface_req_entry` rows are keyed by requirement-key insts.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's row: an InterfaceDecl becomes an IRInterfaceType whose
// requirement entries are keyed by requirement keys (ordinary
// methods get per-decl IRStructKeys). In the dump this appears as an
// `interface_req_entry(<key>, Func(...))` line and an
// `interface(...)` declaration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IFoo { int doIt(int x); }
struct A : IFoo { int doIt(int x) { return x + 1; } }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    A inst;
    buf[0] = inst.doIt(a);
}

// CHECK: interface_req_entry({{.*}}, Func(Int, this_type({{.*}}IFoo), Int))
// CHECK: let %IFoo : Type = interface
