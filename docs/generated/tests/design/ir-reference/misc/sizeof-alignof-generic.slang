//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#size-alignment-count
//META: purpose=`sizeof(T)` and `alignof(T)` on a generic type parameter emit `sizeOf` / `alignOf` insts carrying the type operand plus a data-layout operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the two layout queries survive as insts when the natural
// layout cannot be computed yet, and that both spell out the optional
// second operand. Wrapping the queries in a generic keeps `T` unresolved at
// lowering time; the CHECKs pin `sizeOf(%T..., ScalarLayout)` and
// `alignOf(%T..., ScalarLayout)`, so an inst emitted with the type operand
// alone would not match.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<uint> outputBuffer;

uint querySizeAlign<T>()
{
    return sizeof(T) + alignof(T);
}

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = querySizeAlign<float>();
    outputBuffer[1] = querySizeAlign<uint>();
}

// IR-LABEL: func %querySizeAlign
// IR-DAG: sizeOf(%T{{[A-Za-z0-9_]*}}, ScalarLayout)
// IR-DAG: alignOf(%T{{[A-Za-z0-9_]*}}, ScalarLayout)
