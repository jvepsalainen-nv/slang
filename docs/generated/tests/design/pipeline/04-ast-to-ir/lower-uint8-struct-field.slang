//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A StructDecl whose field is `uint8_t` lowers with the field IR type `UInt8`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis — `uint8_t` as struct field.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Byte { uint8_t b; }

uniform Byte by;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = uint(by.b);
}

// CHECK-LABEL: struct %Byte
// CHECK: field({{.*}}, UInt8)
