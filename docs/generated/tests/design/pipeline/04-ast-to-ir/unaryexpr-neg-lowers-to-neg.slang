//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A unary minus `-a` lowers to a `neg` IR opcode; the doc's BuiltinOperatorExpr fast-path row explicitly covers unary operators (`IRNeg`).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: arithmetic arity axis (unary). The doc's fast-path row
// names unary operators alongside binary ones (`IRNeg`); `-a` is the
// canonical unary arithmetic case, producing a one-operand
// `neg` pure-value inst sibling of `add`/`sub`/`mul`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = -a;
}

// CHECK-LABEL: func %main
// CHECK: neg(%{{.*}})
