//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=DebugValue reports the current value of a DebugVar, taking the variable declaration in operand 0 and the value in operand 1.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pairing between a variable declaration and a value report. The
// CHECK captures the id of the `DebugVar` created for the local and then
// requires a following `DebugValue` whose first operand is that same id, which
// is what makes the report attributable to a specific variable rather than to
// a position in the block.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int local = int(tid.x) + 7;
    buf[0] = local;
}

// CHECK: %[[V:[a-zA-Z0-9_]+]]{{.*}}= DebugVar(%{{[0-9]+}}, {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, %{{[A-Za-z0-9_]+}})
// CHECK: DebugValue(%[[V]], %{{[a-zA-Z0-9_]+}})
