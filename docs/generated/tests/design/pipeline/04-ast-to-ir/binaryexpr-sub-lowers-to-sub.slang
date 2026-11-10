//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A builtin `a - b` (a checker fast-path BuiltinOperatorExpr) lowers to a `sub` IR opcode in the doc's "BuiltinOperatorExpr -> a single pure value inst" row; the IRSub mirror of IRAdd.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: arithmetic-operator axis sibling to `add`. The doc names
// IRAdd / IRMul / IREq as examples; IRSub is the documented `-`
// counterpart. Both operands are `uniform` to defeat constant folding.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a - b;
}

// CHECK-LABEL: func %main
// CHECK: sub(%{{.*}}, %{{.*}})
