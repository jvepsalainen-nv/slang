//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#parameter-direction-and-storage-class-modifiers
//META: doc_section_digest=649151368fdbf5799c5b5465837a522d66af4e2a0ea43703031b86df41af5fcc
//META: purpose=A function without `[ForceInline]` survives as a callable in emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out onto WGSL of the positive counterpart to `[ForceInline]`: without the
// attribute the user helper is preserved as its own WGSL function (modulo name
// mangling); CHECK pins `fn helperNoInline_{{[0-9]+}}`, proving the callable
// survives codegen on this target.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

int helperNoInline(int x)
{
    return x * 3;
}

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = helperNoInline(int(tid.x));
}

//CHECK: fn helperNoInline_{{[0-9]+}}
