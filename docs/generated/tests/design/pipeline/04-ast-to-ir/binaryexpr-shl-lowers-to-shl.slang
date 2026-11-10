//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A builtin `a << n` (a checker fast-path BuiltinOperatorExpr) lowers to an `shl` IR opcode — a pure-value inst representing left-shift in the doc's BuiltinOperatorExpr row.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: shift-operator axis. The doc's pure-value-inst row
// covers any arithmetic Expr; the left-shift `<<` lowers to `shl`
// with the shift amount as the second operand.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a << b;
}

// CHECK-LABEL: func %main
// CHECK: shl(%{{.*}}, %{{.*}})
