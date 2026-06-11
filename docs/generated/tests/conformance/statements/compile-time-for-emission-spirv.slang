//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:16:03+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/statements.md#compile-time-for-statement
//META: doc_section_digest=b1d04c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3
//META: purpose=$for is fully unrolled in the emitted HLSL output (no loop structure, repeated body).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies $for fully unrolls in emitted SPIR-V: the three iterations become three
// OpStore of the constants 0/10/20 with no OpLoopMerge anywhere (no loop structure).
// CHECK pins the three unrolled constants and CHECK-NOT rejects any loop merge.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    int arr[3];
    $for(i in Range(0, 3))
    {
        arr[i] = i * 10;
    }
    outputBuffer[0] = arr[0];
    outputBuffer[1] = arr[1];
    outputBuffer[2] = arr[2];
}

// CHECK-DAG: %int_10 = OpConstant %int 10
// CHECK-DAG: %int_20 = OpConstant %int 20
// CHECK-DAG: OpStore %{{[0-9]+}} %int_10
// CHECK-DAG: OpStore %{{[0-9]+}} %int_20
// CHECK-NOT: OpLoopMerge
