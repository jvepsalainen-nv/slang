//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#global-state
//META: purpose=A module-level type_param declaration lowers to global_generic_param, and its interface constraint lowers to a second global_generic_param holding the witness table.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the module-level generic-parameter surface produces
// `global_generic_param` and that a constraint decl parented by it lowers to
// the same opcode. The CHECK-DAGs require two module-scope insts: one typed
// `Type` (the type parameter `T` itself) and one typed
// `witness_table_t(%IFoo)` (the `T : IFoo` constraint), the witness inst that
// lets a body call an interface method on `T` before `T` is bound. `T` is
// deliberately not used in shader code: the compiler rejects that (E38207)
// because a global generic parameter needs a concrete binding to be used.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int seed;
uniform RWStructuredBuffer<int> buf;

interface IFoo { int run(int x); }

type_param T : IFoo;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = seed;
}

// CHECK-DAG: let  %{{[0-9]+}}	: Type	= global_generic_param
// CHECK-DAG: let  %{{[0-9]+}}	: witness_table_t(%IFoo)	= global_generic_param
