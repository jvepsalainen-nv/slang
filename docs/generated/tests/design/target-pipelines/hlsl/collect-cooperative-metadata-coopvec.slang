//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#context-predicates-and-capability-gates
//META: purpose=collectCooperativeMetadata runs when target capabilities imply cooperative_matrix or cooperative_vector; a CoopVec compute kernel under -profile cs_6_9 emits HLSL that retains the cooperative-vector spelling and the byte-address buffer storage backing it.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the capability gate that enables `collectCooperativeMetadata`:
// it fires only when the target capabilities imply cooperative_matrix or
// cooperative_vector, which on HLSL means a `cs_6_9` profile. The test
// compiles a cooperative-vector accumulate kernel at that profile; CHECK
// asserts the RWByteAddressBuffer storage and the accumulate call site both
// reach the HLSL text, so the module really did carry the cooperative
// capability the gate keys on.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -profile cs_6_9

RWByteAddressBuffer reduceSumOutput;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    CoopVec<half, 4> vec;
    for (int i = 0; i < vec.getCount(); ++i)
        vec[i] = half(i + 1);

    coopVecReduceSumAccumulate(vec, reduceSumOutput, 0);
}

// CHECK: RWByteAddressBuffer
// CHECK: VectorAccumulate
