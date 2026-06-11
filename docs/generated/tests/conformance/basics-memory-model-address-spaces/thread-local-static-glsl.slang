//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`static` (non-groupshared) at global scope belongs to the Thread-local address space; HLSL emits it as a plain `static` variable (per-thread instance).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL) of thread-local-static-hlsl.slang. The non-groupshared `static`
// global that HLSL keeps as a module-scope `static` variable maps to a GLSL module-scope global
// (one per-invocation instance); CHECK asserts GLSL emits `g_perThread` as a plain global int.
// SPIRV elides the per-invocation static entirely; see README ## Untested claims
// (unsupported-on-target).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute

static int g_perThread;

[__NoInline]
int readAndSet(int v)
{
    int old = g_perThread;
    g_perThread = v;
    return old;
}

[numthreads(4, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<int> output)
{
    g_perThread = int(tid.x);
    int prev = readAndSet(int(tid.x) + 10);
    output[tid.x] = prev;
}

// GLSL emits the thread-local static as a plain module-scope global (per-invocation instance).
// GLSL: int g_perThread
