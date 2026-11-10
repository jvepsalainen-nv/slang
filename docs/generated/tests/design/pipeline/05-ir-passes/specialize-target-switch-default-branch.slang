//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#specialization-and-generics
//META: purpose=Expansion: a `__target_switch` whose only matching branch is `default` resolves to the default value after specialize-target-switch — no other case leaks through.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary of `__target_switch`: an `hlsl`-targeted compile against
// a switch that only enumerates `cuda`/`glsl`/`default` resolves to
// the `default` branch (value 999). No surviving target-conditional
// scaffolding remains in the HLSL emit.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

int pickFallback()
{
    __target_switch
    {
        case cuda:    return 1;
        case glsl:    return 2;
        default:      return 999;
    }
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = pickFallback();
}

// HLSL: 999
// HLSL-NOT: __target_switch
