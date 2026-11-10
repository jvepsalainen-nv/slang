//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=When both operands of `+` are compile-time integer literals (uint MAX and `1u`), the IRBuilder constant-folds at lowering and the body emits `store(..., 0 : UInt)` directly — no `add` instruction survives.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: integer-arithmetic at uint MAX + 1, constant-fold path.
// `uint(0xFFFFFFFF) + 1u` is fully literal; the doc's "LiteralExpr
// → constant inst" entry combined with hoistable-value
// deduplication means the IRBuilder folds the sum to `0 : UInt`
// before any `add` is emitted. Verifies that no `add(` survives in
// `main` (with a separator `store`).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint a = uint(0xFFFFFFFF);
    uint b = a + 1u;
    buf[0] = b;
}

// CHECK-LABEL: func %main
// CHECK-NOT: add(
// CHECK: store({{.*}}, 0 : UInt)
