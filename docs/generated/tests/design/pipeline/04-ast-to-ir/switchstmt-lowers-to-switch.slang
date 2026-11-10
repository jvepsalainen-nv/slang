//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A SwitchStmt lowers to a `switch` structured-branch terminator with case-value/case-block operand pairs.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's mapping row lists `SwitchStmt` as a structured branch.
// In IR it lowers to a `switch(scrutinee, %merge, %default, k0, %b0,
// k1, %b1, ...)` terminator — the join (merge) block is an explicit
// operand, matching the doc's structured-CFG claim.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    switch (sel)
    {
        case 0: buf[0] = 100; break;
        case 1: buf[0] = 200; break;
        default: buf[0] = 999; break;
    }
}

// CHECK-LABEL: func %main
// CHECK: switch(%{{.*}}, %{{.*}}, %{{.*}}, 0 : Int, %{{.*}}, 1 : Int, %{{.*}})
