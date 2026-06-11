//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=Function parameters and non-static local variables belong to the Function address space; SPIRV emits mutable locals as `OpVariable` with `Function` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of function-local-var-spirv.slang. A `Counter` struct local is
// passed by `inout` to a non-inlined helper so it survives as a function-scope variable. CHECK
// asserts the emitted code declares the helper's `inout Counter` parameter and a function-local
// `Counter` instance, confirming the per-invocation Function address space on both targets.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

struct Counter { int val; };

// Non-inlined to preserve the local variable in emitted output.
[__NoInline]
int countUp(inout Counter c, int n)
{
    for (int i = 0; i < n; i++)
        c.val++;
    return c.val;
}

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<int> output)
{
    Counter c;
    c.val = 0;
    output[0] = countUp(c, int(tid.x) + 1);
}

// GLSL emits the function param as `inout` and the local as a plain function-scope struct.
// GLSL-DAG: inout Counter{{.*}} c_
// GLSL-DAG: Counter{{.*}} c_
// HLSL emits the function param as `inout` and the local as a plain function-scope struct.
// HLSL-DAG: inout Counter{{.*}} c_
// HLSL-DAG: Counter{{.*}} c_
