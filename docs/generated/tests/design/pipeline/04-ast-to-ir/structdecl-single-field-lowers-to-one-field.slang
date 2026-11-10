//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A StructDecl with exactly one scalar field lowers to an IRStructType carrying exactly one `field(...)` child — sibling of the empty (zero-field is not tested) and the eight-field boundary cases.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: struct-field-count lower edge (one). The doc says
// "StructDecl -> IRStructType with IRStructField children". With a
// single field the struct still lowers — exactly one `field(...)`
// row.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct One { int v; }

uniform int x;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    One o;
    o.v = x;
    buf[0] = o.v;
}

// CHECK-LABEL: struct %One
// CHECK: field(%v, Int)
