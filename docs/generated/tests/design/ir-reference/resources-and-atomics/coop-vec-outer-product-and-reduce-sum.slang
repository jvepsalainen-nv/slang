//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#cooperative-matrix-and-vector
//META: purpose=`coopVecOuterProductAccumulate` and `coopVecReduceSumAccumulate` surface the documented `CoopVecOuterProductAccumulate` and `CoopVecReduceSumAccumulate` opcodes in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two accumulate-into-memory cooperative-vector opcodes.
// Both write through a buffer pointer, so neither result is dead; the
// CHECKs are order-independent because the two calls are independent
// and the lowering is free to interleave them.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWByteAddressBuffer matrixOut;
RWByteAddressBuffer reduceOut;

[numthreads(1, 1, 1)]
void main()
{
    CoopVec<half, 4> vecA;
    CoopVec<half, 8> vecB;
    for (int i = 0; i < vecA.getCount(); ++i)
        vecA[i] = half(i + 1);
    for (int i = 0; i < vecB.getCount(); ++i)
        vecB[i] = half(i + 1);

    coopVecOuterProductAccumulate(
        vecA,
        vecB,
        matrixOut,
        0,
        32,
        CoopVecMatrixLayout.TrainingOptimal,
        CoopVecComponentType.Float16);

    coopVecReduceSumAccumulate(vecA, reduceOut, 0);
}

// IR-LABEL: func %main
// IR-DAG: CoopVecOuterProductAccumulate
// IR-DAG: CoopVecReduceSumAccumulate
