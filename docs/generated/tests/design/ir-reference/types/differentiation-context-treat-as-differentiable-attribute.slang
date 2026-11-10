//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#differentiation-types
//META: purpose=A [TreatAsDifferentiable] primal function gets the Trivial* context opcode pair instead of the ordinary one.
//META: intent=boundary
//META: pipeline_stage=lower-to-ir
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Which of the three context-channel families a function gets is decided at
// semantic-checking time by the differentiation attribute on the primal
// function: each arm of the checker's `IBackwardDifferentiable` extension
// synthesis sets the `irOp` of the two structs it synthesizes.
//
// The two opcodes are not alternatives — both structs are synthesized for every
// differentiable function and the witness table names both — so each test in
// this trio pins the pair, not one entry. One test per row of the attribute
// table, because the rows are separate checker arms rather than one rule.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[TreatAsDifferentiable]
float f(float x) { return x * x; }

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    var dp = diffPair(float(tid.x), 0.0);
    bwd_diff(f)(dp, 1.0);
    outBuf[0] = dp.d;
}

// Re-marking the same function replaces both entries with the Trivial pair.
// CHECK-DAG: witness_table_entry(%{{[0-9]+}},TrivialBackwardDiffIntermediateContextType(%f))
// CHECK-DAG: witness_table_entry(%{{[0-9]+}},TrivialBackwardDiffMinimalContextType(%f))
