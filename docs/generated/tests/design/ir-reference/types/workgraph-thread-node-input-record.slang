//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#work-graph-record-types
//META: purpose=A ThreadNodeInputRecord<T> node parameter is typed ThreadNodeInputRecord(<T>) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The per-thread input record of a thread-launch node has its own type
// opcode, distinct from the broadcasting node's dispatch record even
// though both wrap the same record struct. A thread-launch entry point
// takes ThreadNodeInputRecord<RecordData>; the IR dump is FileChecked at
// `func %main` for ThreadNodeInputRecord(%RecordData), which shows the
// launch mode selects the opcode, not just a decoration.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature -dump-ir -o -

import experimental.workgraph;

struct RecordData { int value; }

RWStructuredBuffer<int> outputBuffer;

[shader("node")]
[NodeLaunch("thread")]
void main(ThreadNodeInputRecord<RecordData> input)
{
    outputBuffer[0] = input.Get().value;
}

// IR: func %main{{.*}}: Func(Void, ThreadNodeInputRecord(%RecordData)
// IR: param %input{{.*}}: ThreadNodeInputRecord(%RecordData)
