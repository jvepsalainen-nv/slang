//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An explicit `float(halfValue)` constructor-style cast lowers to `floatCast(%half)` — float-to-float family.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: explicit-cast axis — half to float. Existing
// `conversion-explicit-cast-...` covers float<->int; this one
// pins the half-to-float `floatCast` opcode.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half h;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = float(h);
}

// CHECK-LABEL: func %main
// CHECK: Float{{.*}}= floatCast(%{{.*}})
