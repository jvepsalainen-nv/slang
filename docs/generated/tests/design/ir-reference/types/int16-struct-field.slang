//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of Int16 lowers to a field(...) row whose type operand is Int16.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of Int16 lowers to a field(...) row whose type
// operand is Int16. Two `int16_t` fields surface two `field(%key,
// Int16)` rows.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Coord { int16_t x; int16_t y; }

uniform Coord c;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(c.x) + int(c.y);
}

// IR-LABEL: struct %Coord
// IR: field(%{{.*}}, Int16)
