//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `BuiltinOperatorExpr` on `half` operands lowers to `add` whose result IR type is `Half`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: pure-value-inst row, half-precision side. The doc's
// "BuiltinOperatorExpr -> IRAdd" claim must hold for narrow floats.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half a;
uniform half b;
uniform RWStructuredBuffer<half> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: func %main
// CHECK: Half{{.*}}= add(%{{.*}}, %{{.*}})
