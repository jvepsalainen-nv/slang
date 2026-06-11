//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:45:13+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: doc_section_digest=2c43dea5ca69ca0e9d2a792df3b8f164e2487c75e25ef796f78839c678589fa1
//META: purpose=HLSL emission pin: `a + b * c` emits with `*` nested inside `+`, confirming the parser groups `*` before `+`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out of the mul-over-add emission claim. Buffer reads feed the
// operands so DCE cannot drop the expression. In SPIR-V the grouping is
// explicit: the OpIMul result is consumed as an operand of OpIAdd. CHECK
// pins OpIMul producing %22 and OpIAdd consuming %22, proving `*` nests
// inside `+`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int a = outputBuffer[0];
    int b = outputBuffer[1];
    int c = outputBuffer[2];
    outputBuffer[3] = a + b * c;
}

// CHECK: %[[MUL:[0-9]+]] = OpIMul %int %{{[A-Za-z0-9_]+}} %{{[A-Za-z0-9_]+}}
// CHECK: OpIAdd %int %{{[A-Za-z0-9_]+}} %[[MUL]]
