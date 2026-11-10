//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=The unsigned-integer scalar opcodes UInt8, UInt16, UInt, UInt64 appear as struct-field types in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The unsigned-integer scalar opcodes UInt8, UInt16, UInt, UInt64
// appear as struct-field types in the IR dump. A struct whose fields
// cover each unsigned-integer width surfaces all four opcodes in the
// IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct UInts { uint8_t a; uint16_t b; uint c; uint64_t d; }

uniform UInts s;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(s.a) + uint(s.b) + s.c + uint(s.d);
}

// IR-LABEL: struct %UInts
// IR: field(%{{.*}}, UInt8)
// IR: field(%{{.*}}, UInt16)
// IR: field(%{{.*}}, UInt)
// IR: field(%{{.*}}, UInt64)
