//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `RWStructuredBuffer<int64_t>` lowers so the element pointer returned by `rwstructuredBufferGetElementPtr` is `Ptr(Int64)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — `int64_t` as the element type of a
// structured buffer. Observes the IR-side per-element `Ptr(...)`
// type produced by the lowered subscript-assignment.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t a;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a;
}

// CHECK-LABEL: func %main
// CHECK: Ptr(Int64){{.*}}= rwstructuredBufferGetElementPtr
