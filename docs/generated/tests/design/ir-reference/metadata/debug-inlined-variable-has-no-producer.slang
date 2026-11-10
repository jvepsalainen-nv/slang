//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=No DebugInlinedVariable opcode is produced anywhere, even when a call is inlined under debug info.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "no producer at HEAD" note on the inlined-variable row. The
// shader forces a call with its own local to be inlined under debug info,
// which is precisely the situation the opcode exists for; the positive
// CHECK-DAGs show the inliner did run and did emit its other debug records, so
// the CHECK-NOT is a real negative rather than a vacuous one. Debug level 1
// also keeps the source record from embedding a copy of this file.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir-after performForceInlining -o - -entry main -stage compute -g1

uniform RWStructuredBuffer<int> buf;

[ForceInline]
int helper(int x)
{
    int t = x * 3;
    return t + 1;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helper(int(tid.x));
}

// CHECK-DAG: = DebugInlinedAt(
// CHECK-DAG: DebugScope(
// CHECK-NOT: DebugInlinedVariable
