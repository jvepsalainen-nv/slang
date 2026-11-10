//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=A source-level enum-to-enum conversion does not reach the `EnumCast` opcode: the checker decomposes it into a `CastEnumToInt` followed by a `CastIntToEnum`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the Enum-to-Enum cell of the conversion table is not
// reachable from Slang source. `Other(c)`, where `c` has enum type
// `Color` and both enums share `int` as their tag type, is coerced to
// the target enum's tag type first and only then wrapped back up, so
// what lowering sees is two nested casts rather than one enum-to-enum
// cast. CHECK asserts the pair appears in that order and that no
// `EnumCast` inst exists anywhere in the dump — the absence is the
// point, since a single `EnumCast` is what a reader of the table would
// otherwise expect.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

enum Color : int { Red = 0, Green = 1 }
enum Other : int { Zero = 0, One = 1 }

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Color c = Color(int(tid.x));
    Other o = Other(c);
    buf[0] = int(o);
}

// IR-LABEL: func %main
// IR: : Enum(Int)	= CastIntToEnum(%{{[A-Za-z0-9_]+}})
// IR: : Int	= CastEnumToInt(%c)
// IR: : Enum(Int)	= CastIntToEnum(%{{[A-Za-z0-9_]+}})
// IR-NOT: EnumCast
