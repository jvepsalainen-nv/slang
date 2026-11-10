//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A BlockStmt lowers to a sequence of basic blocks; the function body has multiple `block %{{.*}}` regions when control flow branches.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc row "BlockStmt → A sequence of basic blocks; locals turn
// into IRVar." A function with an `if` introduces multiple `block`
// regions in the IR (then-block, else-block, merge-block). We CHECK
// for at least three `block` lines inside `main`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (a > 0)
        buf[0] = a;
    else
        buf[0] = -a;
}

// CHECK-LABEL: func %main
// CHECK: block %{{.*}}
// CHECK: block %{{.*}}
// CHECK: block %{{.*}}
// CHECK: block %{{.*}}
