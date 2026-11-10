//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#work-graph-nodes
//META: purpose=A [NodeID(name, arrayIndex)] attribute lowers to a nodeID decoration whose operands are the name string and the array index integer.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the mixed operand shape of `nodeID`: a string identifier plus an
// integer array index. A non-zero index (3) is written so the CHECK can
// distinguish the index operand from the default that an omitted argument
// would produce.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature -dump-ir -o -

import experimental.workgraph;

RWStructuredBuffer<uint> outbuf;

[shader("node")]
[NodeLaunch("broadcasting")]
[NodeDispatchGrid(1, 1, 1)]
[NodeID("ProducerNode", 3)]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outbuf[0] = tid.x;
}

// CHECK: [nodeID("ProducerNode", 3 : Int)]
// CHECK: [nameHint("main")]
// CHECK: func %main
