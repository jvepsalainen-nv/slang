//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#entry-point-scoped-decorations
//META: purpose=Work-graph node attributes lower to their matching decorations on the entry-point function, with the launch mode kept as a string literal rather than an integer.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that lowering preserves the source spelling of a node launch mode.
// `[NodeLaunch("broadcasting")]` and `[NodeDispatchGrid(1, 1, 1)]` are attached
// to the entry point as decorations; the CHECK requires the launch decoration's
// operand to still be the quoted string `"broadcasting"`, which is what lets
// HLSL emit re-emit the source name instead of a numeric mode. The dispatch-grid
// decoration is checked alongside it to show the whole node-attribute group
// takes the same route.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -stage node -entry main -profile lib_6_8 -experimental-feature

import experimental.workgraph;

struct OutputRecord { int value; };

[shader("node")]
[NodeLaunch("broadcasting")]
[NodeDispatchGrid(1, 1, 1)]
[numthreads(1, 1, 1)]
void main([MaxRecords(4)] NodeOutput<OutputRecord> outputs)
{
}

// CHECK-DAG: [nodeLaunch("broadcasting")]
// CHECK-DAG: [nodeDispatchGrid(1 : Int, 1 : Int, 1 : Int)]
// CHECK: func %main
