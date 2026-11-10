//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A SwitchStmt with five explicit cases lowers to a single `switch(...)` terminator carrying five case-value / case-block operand pairs in source order.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: switch-case-count axis — many cases. Five case-value/
// case-block pairs in declaration order appear inside the `switch`
// operand list (after scrutinee, merge, default). The doc's row
// describes this structure once; verifies it scales.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    switch (sel)
    {
        case 0: buf[0] = 0; break;
        case 1: buf[0] = 1; break;
        case 2: buf[0] = 2; break;
        case 3: buf[0] = 3; break;
        case 4: buf[0] = 4; break;
        default: buf[0] = -1; break;
    }
}

// CHECK-LABEL: func %main
// CHECK: switch(%{{.*}}, %{{.*}}, %{{.*}}, 0 : Int, %{{.*}}, 1 : Int, %{{.*}}, 2 : Int, %{{.*}}, 3 : Int, %{{.*}}, 4 : Int, %{{.*}})
