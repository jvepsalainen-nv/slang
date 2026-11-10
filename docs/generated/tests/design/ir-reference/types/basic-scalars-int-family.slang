//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=The signed-integer scalar opcodes Int8, Int16, Int, Int64 appear as struct-field types in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The signed-integer scalar opcodes Int8, Int16, Int, Int64 appear as
// struct-field types in the IR dump. A struct whose fields cover each
// of these scalar widths surfaces all four opcodes in one IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Ints { int8_t a; int16_t b; int c; int64_t d; }

uniform Ints s;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(s.a) + int(s.b) + int(s.c) + int(s.d);
}

// IR-LABEL: struct %Ints
// IR: field(%{{.*}}, Int8)
// IR: field(%{{.*}}, Int16)
// IR: field(%{{.*}}, Int)
// IR: field(%{{.*}}, Int64)
