//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:16:03+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: doc_section_digest=b57a8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7
//META: purpose=A variable declared in the for-loop init has scope limited to the for statement.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the for-init variable is scoped to its for statement in WGSL emit: two
// successive loops redeclare `i`, and the compiler emits two separate loops whose
// bound checks are `< i32(3)` then `< i32(5)`. CHECK pins both bound comparisons.
//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    int sum1 = 0;
    for (int i = 0; i < 3; i++)
        sum1 += i;

    int sum2 = 0;
    for (int i = 0; i < 5; i++)  // same name `i` is valid because previous scope ended
        sum2 += i;

    outputBuffer[0] = sum1;
    outputBuffer[1] = sum2;
}

// CHECK-DAG: if(i_{{[0-9]+}} < i32(3))
// CHECK-DAG: if(i_{{[0-9]+}} < i32(5))
