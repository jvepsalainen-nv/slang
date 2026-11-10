//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `BuiltinOperatorExpr` on `uint64_t` operands lowers to `add` whose result IR type is `UInt64`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: pure-value-inst row, 64-bit unsigned side.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint64_t a;
uniform uint64_t b;
uniform RWStructuredBuffer<uint64_t> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: func %main
// CHECK: UInt64{{.*}}= add(%{{.*}}, %{{.*}})
