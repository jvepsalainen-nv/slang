//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debugscope-and-debugnoscope
//META: purpose=A DebugScope opens a lexical scope whose operand 0 references the enclosing scope, a DebugFunction for a function-level scope, and whose operand 1 records the inlining context.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies scope chaining terminates at the owning function record. The
// snapshot is taken right after force-inlining, the pass that builds these
// chains, and debug level 1 keeps the module's source record from embedding a
// copy of this file. The CHECK captures the inlined callee's function record
// id and the inlining-frame id created at the call site, then requires the
// scope instruction to carry exactly those two ids in that order.

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

// CHECK: %[[DF:[0-9]+]]{{.*}}= DebugFunction("helper"
// CHECK: %[[IA:[0-9]+]]{{.*}}= DebugInlinedAt(
// CHECK-NEXT: DebugScope(%[[DF]], %[[IA]])
