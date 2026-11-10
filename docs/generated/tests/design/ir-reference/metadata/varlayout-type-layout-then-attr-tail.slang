//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#varlayout-and-entrypointlayout
//META: purpose=A varLayout has one fixed operand, the type layout, followed by a variable-length tail of attributes.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the operand shape of a per-variable layout. The buffer parameter's
// `varLayout` is captured with two operands; following the first must reach a
// concrete type-layout opcode and following the second must reach an `offset`
// attribute. That combination is only consistent with "operand 0 is the type
// layout, everything after it is the attribute tail".

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: %{{[0-9]+}}{{.*}}= varLayout(%[[TL:[0-9]+]], %[[OFF:[0-9]+]])
// CHECK: %[[OFF]]{{.*}}= offset(
// CHECK: %[[TL]]{{.*}}= structuredBufferTypeLayout(
