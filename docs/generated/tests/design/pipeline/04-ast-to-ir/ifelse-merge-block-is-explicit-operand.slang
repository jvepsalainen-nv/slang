//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=Structured branches (`ifElse`) encode the join (merge) point as an explicit operand on the terminator; the two branches reach it via `unconditionalBranch`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says "structured branches whose join point is an explicit
// operand on the terminator". For `ifElse` the four operands are
// `(cond, %then, %else, %merge)`; after the then- and else-blocks
// finish writing to the buffer, both branches end with
// `unconditionalBranch(%merge)`. We verify both halves: the
// `ifElse` terminator and the `unconditionalBranch` join.

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
// CHECK: unconditionalBranch(%{{.*}})
// CHECK: unconditionalBranch(%{{.*}})
