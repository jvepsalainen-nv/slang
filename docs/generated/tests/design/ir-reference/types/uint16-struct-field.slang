//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of UInt16 lowers to a field(...) row carrying UInt16.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of UInt16 lowers to a field(...) row carrying UInt16.
// A `uint16_t` field surfaces a `field(%key, UInt16)` row.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Span { uint16_t start; uint16_t len; }

uniform Span s;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(s.start) + uint(s.len);
}

// IR-LABEL: struct %Span
// IR: field(%{{.*}}, UInt16)
