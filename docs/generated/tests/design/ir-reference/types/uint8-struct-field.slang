//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: struct field of UInt8 surfaces a field(...) row carrying UInt8.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// struct field of UInt8 surfaces a field(...) row carrying UInt8. A
// struct holding a `uint8_t` field produces a `field(%key, UInt8)` row
// in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Byte { uint8_t value; }

uniform Byte b;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(b.value);
}

// IR-LABEL: struct %Byte
// IR: field(%{{.*}}, UInt8)
