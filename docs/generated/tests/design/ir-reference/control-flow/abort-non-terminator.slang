//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#abort
//META: purpose=The abort(format, args...) builtin lowers to an Abort instruction that is not an IR terminator: like discard, it sits inside the block and the block's real terminator (unconditionalBranch to the post-if merge) follows it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies Abort is not a TerminatorInst: an abort() call placed as
// the last statement of an if-arm appears in the IR dump as an Abort
// instruction with the arm block's real terminator — the branch to
// the post-if merge — on the line after it, the same in-block shape
// the catalog documents for discard.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int g;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    if (g > 7)
        abort("g out of range");
    buf[0] = g;
}

// CHECK-LABEL: func %main
// CHECK: Abort(
// CHECK-NEXT: unconditionalBranch(%{{[0-9]+}})
