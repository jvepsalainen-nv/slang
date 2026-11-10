//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A builtin arithmetic site (`a + b`, a checker fast-path BuiltinOperatorExpr) lowers to a single pure-value IR opcode (`add`) — the doc's "single pure value inst (IRAdd, IRMul, ...)" row.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `a + b` with two `uniform` operands lowers to `add(%a, %b)`.
// Non-constant operands are required because constant folding
// collapses literal arithmetic before lowering can dump it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: func %main
// CHECK: add(%{{.*}}, %{{.*}})
