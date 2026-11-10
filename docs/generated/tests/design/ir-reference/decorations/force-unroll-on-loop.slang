//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#loop-and-branch-hints
//META: purpose=Boundary - the [ForceUnroll] attribute is loop-statement-only and produces a ForceUnroll decoration on the loop with an integer operand recording the requested unroll count (0 when omitted).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive side of the placement rule its negative sibling
// pins, and the observed operand shape. The decoration is listed with no
// operands, but the dump prints one integer, so the CHECK matches
// `[ForceUnroll(N : Int)]` with the count wildcarded; the mismatch with the
// documented arity is recorded as a doc gap rather than hidden.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int s = 0;
    [ForceUnroll]
    for (int i = 0; i < 4; i++) s += int(tid.x) * i;
    buf[0] = s;
}

// CHECK: [ForceUnroll({{[0-9]+}} : Int)]
