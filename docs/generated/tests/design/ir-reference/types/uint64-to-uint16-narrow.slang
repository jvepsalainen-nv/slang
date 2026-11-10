//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: narrowing from UInt64 to UInt16 yields a UInt16-typed cast value, distinguishing the two unsigned widths.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// narrowing from UInt64 to UInt16 yields a UInt16-typed cast value,
// distinguishing the two unsigned widths. A `uint16_t(v)` cast from a
// `uint64_t` value produces a `Cast` instruction whose result type is
// `UInt16`, pulling the value down from the largest unsigned scalar.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint64_t v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    uint16_t narrowed = uint16_t(v);
    buf[0] = uint(narrowed);
}

// IR: let {{.*}}%narrowed{{.*}}: UInt16{{.*}}= {{.*}}Cast
