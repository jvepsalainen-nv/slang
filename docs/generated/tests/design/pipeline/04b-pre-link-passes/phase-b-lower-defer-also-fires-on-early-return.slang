//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#lowerdefer
//META: purpose=Phase B's lowerDefer (B3) duplicates the deferred body to the end of every dominated block whose terminator leaves the deferred region, so an early return also runs it.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the multi-exit boundary of the defer lowering. The enclosing
// scope has two exits -- an early `return` inside the `if`, and the normal
// fall-through -- so the duplication rule must place the deferred store on
// both. The condition is fed from a `uniform` so neither branch is folded
// away before the snapshot, and the CHECKs require the deferred store of
// `200` to appear twice while the `defer` opcode is gone.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    defer { buf[1] = 200; }
    if (a > 0) { buf[0] = 1; return; }
    buf[0] = 2;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK: store({{.*}}, 200 : Int)
// CHECK: store({{.*}}, 200 : Int)
// CHECK-NOT: = defer(
