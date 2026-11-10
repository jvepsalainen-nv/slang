//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#phase-c-mandatory-optimization-passes
//META: purpose=Phase C's simplifyCFG (C3) removes the empty and unreachable blocks left after constant propagation resolves a branch condition.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a statically-taken branch leaves no control flow behind.
// C2 resolves the `true` condition, then C3 and the pre-linking peephole
// prune the untaken arm and the now-empty blocks. The CHECKs assert the
// taken arm's store survives while neither the `ifElse` terminator nor the
// untaken arm's sentinel value appears in the snapshot.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (true) { buf[0] = a; }
    else { buf[0] = 9999; }
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK: store({{.*}}, %a)
// CHECK-NOT: ifElse(
// CHECK-NOT: 9999 : Int
