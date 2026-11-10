//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=AppendStructuredBuffer<T> and ConsumeStructuredBuffer<T> uniforms lower to distinct IR type opcodes each carrying the element type and a data-layout operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The append and consume flavours of a structured buffer are separate
// type opcodes even though they share the element-type plus data-layout
// operand shape of the read-write flavour. Both uniforms are declared
// and used in one kernel; the dump is FileChecked for each named
// global_param carrying its own opcode with `Int, DefaultLayout`, which
// shows the surface flavour picks the opcode and the layout marker is
// carried as the second operand.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage compute -entry main -dump-ir -o -

AppendStructuredBuffer<int> appendBuf;
ConsumeStructuredBuffer<int> consumeBuf;

[numthreads(1, 1, 1)]
void main()
{
    appendBuf.Append(consumeBuf.Consume());
}

// IR-DAG: let %appendBuf{{.*}}: AppendStructuredBuffer(Int, DefaultLayout{{.*}}= global_param
// IR-DAG: let %consumeBuf{{.*}}: ConsumeStructuredBuffer(Int, DefaultLayout{{.*}}= global_param
