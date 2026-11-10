//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debugline
//META: purpose=DebugLine pins an instruction to a source range with five operands: the source file, the start and end lines, and the start and end columns.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the range record's arity and its file operand. The CHECK captures
// the module's `DebugSource` id and then requires a `DebugLine` whose first
// operand is that id followed by exactly four unsigned literals, so a record
// with a different operand count would fail.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: %[[SRC:[0-9]+]]{{.*}}= DebugSource(
// CHECK: DebugLine(%[[SRC]], {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, {{[0-9]+}} : UInt)
