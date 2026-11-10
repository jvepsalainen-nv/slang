//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#lowerdefer
//META: purpose=Phase B's lowerDefer (B3) duplicates the deferred body at the point control leaves the deferred region and removes every IRDefer inst.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the straight-line case of the defer lowering: a `defer` block
// written before the ordinary body still executes after it. The CHECKs
// require the ordinary store of `1` to appear before the deferred store of
// `100` in the post-Phase-D snapshot, and the CHECK-NOT asserts the
// `defer` opcode itself is gone so no later pass has to model it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    defer { buf[1] = 100; }
    buf[0] = 1;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK: store({{.*}}, 1 : Int)
// CHECK: store({{.*}}, 100 : Int)
// CHECK-NOT: = defer(
