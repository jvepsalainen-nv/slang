//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A builtin `a != b` (a checker fast-path BuiltinOperatorExpr) lowers to `cmpNE` — sibling of cmpEQ in the doc's BuiltinOperatorExpr row.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: comparison-operator axis. Completes the equality pair
// (cmpEQ + cmpNE). The doc lists IREq as the example; cmpNE is the
// negation peer pure-value inst.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (a != b)
        buf[0] = 1;
    else
        buf[0] = 0;
}

// CHECK-LABEL: func %main
// CHECK: cmpNE(%{{.*}}, %{{.*}})
