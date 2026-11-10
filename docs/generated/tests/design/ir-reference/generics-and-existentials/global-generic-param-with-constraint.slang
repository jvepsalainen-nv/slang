//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#generic-application
//META: purpose=A constrained module-scope type_param emits a second global_generic_param for the constraint's witness table alongside the one for the type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies that the constraint attached to a module-scope generic parameter is
// itself a module-scope generic parameter. `type_param T : IFoo` therefore
// yields two `global_generic_param` values: one typed `Type` for `T` and one
// typed `witness_table_t(%IFoo)` for the conformance. The parameter is left
// unused in shader code (a used, unbound one is rejected with E38207), and the
// CHECKs pin both parameters in the lowered IR dump.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };

type_param T : IFoo;

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = 1;
}

// CHECK-DAG: let  %{{[0-9]+}} : Type = global_generic_param
// CHECK-DAG: let  %{{[0-9]+}} : witness_table_t(%IFoo) = global_generic_param
