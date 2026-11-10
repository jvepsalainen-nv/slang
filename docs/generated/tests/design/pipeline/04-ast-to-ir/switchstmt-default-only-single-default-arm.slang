//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A SwitchStmt with a default and a single explicit case lowers to a `switch(scrutinee, merge, default, k, block)` — minimum non-trivial case count.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: switch-case-count axis at one explicit case. The doc's
// row says `SwitchStmt` lowers to a `switch` terminator with
// "case-value/case-block operand pairs and a merge operand". With
// one case, exactly one `(k, block)` pair appears after the default.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    switch (sel)
    {
        case 0: buf[0] = 100; break;
        default: buf[0] = 999; break;
    }
}

// CHECK-LABEL: func %main
// CHECK: switch(%{{.*}}, %{{.*}}, %{{.*}}, 0 : Int, %{{.*}})
