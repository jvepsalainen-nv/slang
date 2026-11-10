//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#work-graph-record-types
//META: purpose=A GroupNodeInputRecords<T> coalescing-node parameter is typed GroupNodeInputRecords(<T>) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A coalescing node receives an indexable array of input records, and
// that array has its own type opcode parameterised by the record struct.
// A coalescing entry point takes [MaxRecords(8)]
// GroupNodeInputRecords<RecordData> and indexes it; the IR dump is
// FileChecked at `func %main` for GroupNodeInputRecords(%RecordData) and
// for the maxRecords decoration sitting on the parameter, which shows the
// record count is a decoration rather than a type operand.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature -dump-ir -o -

import experimental.workgraph;

struct RecordData { int value; }

RWStructuredBuffer<int> outputBuffer;

[shader("node")]
[NodeLaunch("coalescing")]
[numthreads(1, 1, 1)]
void main([MaxRecords(8)] GroupNodeInputRecords<RecordData> input)
{
    outputBuffer[0] = input.Get(0).value;
}

// IR: func %main{{.*}}: Func(Void, GroupNodeInputRecords(%RecordData)
// IR: maxRecords(8 : Int)
// IR: param %input{{.*}}: GroupNodeInputRecords(%RecordData)
