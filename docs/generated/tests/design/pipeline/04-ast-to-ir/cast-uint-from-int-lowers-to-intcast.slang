//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An explicit constructor-style cast between two integer widths/signednesses (`uint(intValue)`) lowers to an `intCast` IR opcode — the integer-to-integer counterpart of `castFloatToInt`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: explicit-cast axis — integer-to-integer. The existing
// `conversion-explicit-cast-...` test covers float<->int conversions;
// `uint(int_x)` is the same pure-value-inst family but a different
// IR opcode (`intCast`) because both source and dest are integral.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint u = uint(a);
    buf[0] = u;
}

// CHECK-LABEL: func %main
// CHECK: intCast(%{{.*}})
