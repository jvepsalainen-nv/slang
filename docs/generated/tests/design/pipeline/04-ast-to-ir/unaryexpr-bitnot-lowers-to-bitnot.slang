//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A unary `~a` (bitwise NOT) lowers to a `bitnot` IR opcode — a pure-value inst in the doc's BuiltinOperatorExpr row (bitwise / unary fast path).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: unary bitwise axis. Sibling of `neg` for the bitwise
// side; the doc's BuiltinOperatorExpr fast-path row names bitwise
// and unary operators explicitly.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = ~a;
}

// CHECK-LABEL: func %main
// CHECK: bitnot(%{{.*}})
