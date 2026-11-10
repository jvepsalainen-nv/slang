//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An IfStmt lowers to an `ifElse` structured-branch terminator whose merge / join point is an explicit operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A user-level `if/else` lowers to an `ifElse(cond, %then, %else,
// %merge)` terminator. The merge block appears as an explicit
// operand — the doc's "structured branches whose join point is an
// explicit operand on the terminator" claim.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (a > 0)
        buf[0] = 1;
    else
        buf[0] = 2;
}

// CHECK-LABEL: func %main
// CHECK: ifElse(%{{.*}}, %{{.*}}, %{{.*}}, %{{.*}})
