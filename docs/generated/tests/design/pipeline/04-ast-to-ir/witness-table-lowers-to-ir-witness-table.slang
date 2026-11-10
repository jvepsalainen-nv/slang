//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#generics-and-existentials
//META: purpose=A WitnessTable synthesized in checking lowers to an `IRWitnessTable` whose entries map interface requirements to concrete implementations.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says "Witness tables (computed by slang-check-conformance)
// become IRWitnessTable insts whose entries map interface
// requirements to the concrete implementations." In the IR dump we
// see a `witness_table %{{.*}} : witness_table_t(%IFoo)(%A)`
// declaration with a `witness_table_entry(%req, %impl)` row.

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

// CHECK: witness_table %{{.*}} : witness_table_t(%IFoo)(%A)
// CHECK: witness_table_entry(%{{.*}},%{{.*}})
