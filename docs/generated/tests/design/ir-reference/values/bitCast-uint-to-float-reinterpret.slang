//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Boundary: `bit_cast<float>(uintVal)` lowers to `bitCast(%a)` with `Float` result type — reinterpret across the signed/unsigned + int/float boundary.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The existing smoke test covers `bit_cast<float>(int)`. This
// boundary probe reinterprets a `uint` (unsigned) as a `float`,
// crossing both the signedness and the int/float type boundary
// in one step.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<float> fbuf;

[numthreads(1, 1, 1)]
void main()
{
    fbuf[0] = bit_cast<float>(a);
}

// IR-LABEL: func %main
// IR: bitCast(%a)
