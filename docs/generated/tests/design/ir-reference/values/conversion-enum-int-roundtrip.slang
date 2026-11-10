//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=The `emitCast` Int-to-Enum entry lowers `MyEnum(intValue)` to `CastIntToEnum`, and the Enum-to-Int entry lowers `int(enumValue)` to `CastEnumToInt`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the two enum-tag conversions are separate opcodes and
// that each direction picks the right one. A `uniform int` is converted
// into the enum type and back out again, so neither direction can be
// constant-folded away and both must appear. CHECK asserts
// `CastIntToEnum(%a)` producing an `Enum(Int)` result and
// `CastEnumToInt` consuming that same value, which pins the direction
// of each cast rather than just their presence.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

enum Color : int
{
    Red = 0,
    Green = 1,
    Blue = 2,
}

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Color c = Color(a);
    buf[0] = int(c);
}

// IR-LABEL: func %main
// IR: let  %c	: Enum(Int)	= CastIntToEnum(%a)
// IR: : Int	= CastEnumToInt(%c)
