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

// Verifies $for fully unrolls in emitted GLSL: the three iterations become three
// straight-line assignments arr_0[0]=0, arr_0[1]=10, arr_0[2]=20 with no `for(`
// loop construct. CHECK pins each unrolled store and CHECK-NOT rejects any loop.
//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry computeMain -stage compute

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

// CHECK-DAG: arr_{{[0-9]+}}[0] = 0
// CHECK-DAG: arr_{{[0-9]+}}[1] = 10
// CHECK-DAG: arr_{{[0-9]+}}[2] = 20
// CHECK-NOT: for(
