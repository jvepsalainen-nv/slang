//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#builtinrequirementkey--builtinrequirementkey
//META: purpose=A struct conforming to IDifferentiable produces witness-table rows keyed by builtinRequirementKey insts carrying an integer BuiltinRequirementKind operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the second requirement-key spelling. Conformance to a built-in
// interface is keyed by kind rather than by a per-declaration symbol, so the
// key inst carries an integer operand instead of a name. The CHECK-DAGs assert
// the conformance table for the user struct and at least one integer-operand
// key exist.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct DiffData : IDifferentiable { float v; };

uniform float inVal;
uniform RWStructuredBuffer<float> buf;

float useDiff<T : IDifferentiable>(T t, float x) { return x; }

[numthreads(1, 1, 1)]
void main()
{
    DiffData d;
    d.v = inVal;
    buf[0] = useDiff<DiffData>(d, inVal);
}

// CHECK-DAG: witness_table %{{[0-9]+}} : witness_table_t(%{{[A-Za-z0-9_]+}})(%DiffData)
// CHECK-DAG: builtinRequirementKey({{[0-9]+}} : Int)
