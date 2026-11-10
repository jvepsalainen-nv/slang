//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#nodelaunch-and-the-work-graph-node-decorations
//META: purpose=A [NodeLaunch("coalescing")] attribute lowers to nodeLaunch("coalescing"), and a [MaxRecords(N)] on the input-record parameter lowers to maxRecords on that parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third launch-mode spelling keeps its own string operand, and
// that `maxRecords` can sit on a parameter rather than on the node function
// - the doc says that attribute is accepted in either position. The CHECK
// sequence walks from the function-level `nodeLaunch` through `func %main`
// into the parameter list, where the parameter-level `maxRecords` must
// appear.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature -dump-ir -o -

import experimental.workgraph;

struct MyRecord { uint value; };

RWStructuredBuffer<uint> outbuf;

[shader("node")]
[NodeLaunch("coalescing")]
[numthreads(4, 1, 1)]
void main([MaxRecords(8)] GroupNodeInputRecords<MyRecord> inputs)
{
    outbuf[0] = inputs.Get(0).value;
}

// CHECK: [nodeLaunch("coalescing")]
// CHECK: func %main
// CHECK: [maxRecords(8 : Int)]
// CHECK: param %inputs
