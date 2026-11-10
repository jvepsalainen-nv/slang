//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of UInt64 lowers to a field(...) row carrying UInt64.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of UInt64 lowers to a field(...) row carrying UInt64.
// A `uint64_t` field surfaces a `field(%key, UInt64)` row.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Handle64 { uint64_t opaque; }

uniform Handle64 h;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(h.opaque);
}

// IR-LABEL: struct %Handle64
// IR: field(%{{.*}}, UInt64)
