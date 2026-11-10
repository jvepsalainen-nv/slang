//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#the-work-graph-record-types
//META: purpose=EmptyNodeInput, EmptyNodeOutput and EmptyNodeOutputArray are nullary type opcodes carrying no element-type operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The three payload-free work-graph record opcodes take no operand at
// all, unlike their record-carrying siblings which take the record struct
// as operand 0. A coalescing node declares all three payload-free
// parameters; the IR dump is FileChecked for `Func(Void, EmptyNodeInput,
// EmptyNodeOutput, EmptyNodeOutputArray)` — the bare opcode names with no
// parenthesised operand list is exactly what "nullary" means here, and
// the closing parenthesis in the pattern pins that nothing follows them.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage node -entry main -profile lib_6_8 -experimental-feature -dump-ir -o -

import experimental.workgraph;

[shader("node")]
[NodeLaunch("coalescing")]
[numthreads(4, 1, 1)]
void main(
    EmptyNodeInput input,
    EmptyNodeOutput outputA,
    [AllowSparseNodes] EmptyNodeOutputArray outputArr)
{
    uint count = input.Count();
    if (outputA.IsValid())
        outputA.ThreadIncrementOutputCount(count);
    EmptyNodeOutput elem = outputArr[0];
    if (elem.IsValid())
        elem.ThreadIncrementOutputCount(1);
}

// IR: func %main{{.*}}: Func(Void, EmptyNodeInput, EmptyNodeOutput, EmptyNodeOutputArray)
// IR: let %elem{{.*}}: EmptyNodeOutput
