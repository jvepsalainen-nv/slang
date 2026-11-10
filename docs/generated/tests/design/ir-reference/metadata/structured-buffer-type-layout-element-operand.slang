//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#layout-family
//META: purpose=A structured-buffer parameter lowers to a structuredBufferTypeLayout whose operand 0 is the element type layout.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fixed operand of the structured-buffer layout record. The
// buffer's element is `int`, so following operand 0 must land on a type layout
// reporting a 4-byte byte-unit size, while operand 1 is the buffer's own
// resource-kind size attribute -- the shape that distinguishes an element
// operand from a plain attribute tail.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: = structuredBufferTypeLayout(%[[ELEM:[0-9]+]], %[[SZ:[0-9]+]])
// CHECK: %[[SZ]]{{.*}}= size(
// CHECK: %[[ELEM]]{{.*}}= typeLayout(%[[ESZ:[0-9]+]], %{{[0-9]+}})
// CHECK: %[[ESZ]]{{.*}}= size(8 : Int, 4 : Int)
