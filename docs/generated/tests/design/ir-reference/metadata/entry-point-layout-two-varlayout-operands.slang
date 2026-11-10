//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#varlayout-and-entrypointlayout
//META: purpose=An EntryPointLayout has exactly two fixed operands and no attribute tail: the parameters layout and the result layout, both varLayouts.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the entry-point layout's distinct shape. The CHECK pins the closing
// parenthesis right after the second operand, so a third operand (an attribute
// tail) would fail the match, and each captured operand is then shown to be
// defined by a `varLayout` -- the documented parameters/result pair.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: = EntryPointLayout(%[[PARAMS:[0-9]+]], %[[RESULT:[0-9]+]])
// CHECK: %[[RESULT]]{{.*}}= varLayout(
// CHECK: %[[PARAMS]]{{.*}}= varLayout(
