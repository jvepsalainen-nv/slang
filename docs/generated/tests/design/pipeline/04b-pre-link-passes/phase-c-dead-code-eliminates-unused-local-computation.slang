//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#phase-c-mandatory-optimization-passes
//META: purpose=Phase C's per-function eliminateDeadCode sweep (C5) removes instructions whose results are never used, while keepExportsAlive leaves the entry point itself in place.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-function DCE step. The multiply is fed from a `uniform`
// so constant folding cannot claim credit for removing it; the only reason
// it can disappear is that nothing reads `dead`. The CHECK-NOT looks for
// the distinctive multiplier literal inside `main`, and the surviving
// `func %main` label shows the sweep's keep-exports-alive setting did not
// take the entry point with it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int dead = a * 999;
    buf[0] = 1;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK-NOT: 999 : Int
