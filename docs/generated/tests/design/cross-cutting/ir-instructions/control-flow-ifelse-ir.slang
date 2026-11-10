//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#control-flow-instructions
//META: purpose=An `if`/`else` statement lowers to the `ifElse` terminator plus `unconditionalBranch` joins.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's control-flow terminator rows. An `if/else` produces
// then/else/merge basic blocks joined by the `ifElse` terminator and
// `unconditionalBranch` back-edges to the merge block, matching the
// `TerminatorInst` family entries.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (a > 0)
        buf[0] = 1;
    else
        buf[0] = 2;
}

// IR-LABEL: func %main
// IR: ifElse(%{{.*}}, %{{.*}}, %{{.*}}, %{{.*}})
// IR: unconditionalBranch(%{{.*}})
// IR: unconditionalBranch(%{{.*}})
