//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#enum
//META: purpose=An enum declaration lowers to the Enum parent opcode whose single operand is its integer tag type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies EnumDecl lowering produces the Enum opcode carrying the
// underlying integer tag type as its operand. A two-case enum is
// selected at runtime and its value stored through an int cast so the
// type is used; the Enum type is hoistable, so the dump prints it
// inline as `Enum(Int)` at each use site (e.g. in the synthesized
// members' signatures), which pins both the opcode and its single
// default-Int tag-type operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

enum Color
{
    Red = 3,
    Green = 7,
}

uniform uint pick;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Color c = (pick != 0) ? Color.Red : Color.Green;
    buf[0] = int(c);
}

// IR: Enum(Int)
