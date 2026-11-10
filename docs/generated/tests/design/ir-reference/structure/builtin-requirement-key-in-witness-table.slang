//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#builtinrequirementkey--builtinrequirementkey
//META: purpose=Conforming a user struct to the built-in interface IDifferentiable produces builtinRequirementKey insts as the requirement keys, alongside the conformance's witness_table.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a recognized built-in requirement is keyed by the
// `builtinRequirementKey` opcode rather than by an ordinary named `key`.
// `struct Grad : IDifferentiable` forces the user module to materialize
// requirement keys for IDifferentiable's built-in members; the CHECK-DAGs
// require the dump to hold a `builtinRequirementKey(` definition and the
// `%Grad` conformance table those keys belong to.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float u;
uniform RWStructuredBuffer<float> buf;

struct Grad : IDifferentiable
{
    float v;
}

[numthreads(1, 1, 1)]
void main()
{
    Grad g;
    g.v = u;
    buf[0] = g.v;
}

// CHECK-DAG: = builtinRequirementKey(
// CHECK-DAG: witness_table %{{[0-9]+}}{{.*}}(%Grad)
