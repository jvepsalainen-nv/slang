//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `BuiltinOperatorExpr` on `double` operands lowers to `mul` whose result IR type is `Double`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: pure-value-inst row, double-precision side.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double a;
uniform double b;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a * b;
}

// CHECK-LABEL: func %main
// CHECK: Double{{.*}}= mul(%{{.*}}, %{{.*}})
