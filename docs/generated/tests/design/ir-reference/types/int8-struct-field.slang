//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of Int8 type lowers to a field(...) row carrying Int8 as its type operand.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of Int8 type lowers to a field(...) row carrying Int8
// as its type operand. A struct with two `int8_t` fields surfaces two
// `field(%key, Int8)` rows in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Pair { int8_t a; int8_t b; }

uniform Pair p;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(p.a) + int(p.b);
}

// IR-LABEL: struct %Pair
// IR: field(%{{.*}}, Int8)
