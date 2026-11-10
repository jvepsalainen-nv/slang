//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A builtin `a * b` (a checker fast-path BuiltinOperatorExpr) lowers to a `mul` IR opcode, matching the doc's `IRMul` exemplar of the BuiltinOperatorExpr row.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: arithmetic-operator axis. The doc explicitly cites
// IRMul as an example in the "Pure value insts (IRAdd, IRMul, IREq,
// ...)" sentence. Verifies the multiply opcode name.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a * b;
}

// CHECK-LABEL: func %main
// CHECK: mul(%{{.*}}, %{{.*}})
