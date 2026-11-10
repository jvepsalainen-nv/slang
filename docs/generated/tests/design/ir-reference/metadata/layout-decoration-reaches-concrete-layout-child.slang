//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#layout
//META: purpose=A laid-out instruction is connected to its layout by a layout decoration whose operand is a concrete Layout child.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented navigation step from a laid-out inst to its layout
// data. The CHECK captures the id referenced by a `[layout(...)]` decoration
// and then requires that id's defining instruction to be one of the concrete
// layout opcodes -- which is what makes "follow the decoration to reach the
// offset/size data" a valid rule for a reader walking the IR.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [layout(%[[L:[0-9]+]])]
// CHECK: %[[L]]{{[^0-9].*}}= {{(varLayout|EntryPointLayout|typeLayout|structTypeLayout)}}
