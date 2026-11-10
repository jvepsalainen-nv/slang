//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#ssa-construction-and-basic-cleanup
//META: purpose=Negative boundary: `uint << 32` shifts by exactly the operand bit-width — the operator-shift-overflow pass emits `E41030` `left shift overflow`.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary shift count: 32 on a 32-bit `uint` is documented as
// overflow (>=N for N-bit operand). Distinct from the existing
// `<< 40` (signed `int`) test in this bundle.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<uint> buf;
uniform uint a;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint x = a;
    x = x << 32;
//CHECK:  ^^ left shift overflow
// CHECK: E41030
    buf[0] = x;
}
