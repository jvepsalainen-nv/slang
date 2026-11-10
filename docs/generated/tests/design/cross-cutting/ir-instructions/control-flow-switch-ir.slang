//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#control-flow-instructions
//META: purpose=A `switch` statement lowers to the `switch` terminator.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `switch` terminator row. A multi-case `switch` on a
// non-constant `uniform` selector lowers to the `switch` terminator in
// the IR dump; the runtime selector keeps the branch from being folded
// to a single case.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    switch (sel)
    {
    case 0: buf[0] = 10; break;
    case 1: buf[0] = 20; break;
    default: buf[0] = 30; break;
    }
}

// IR-LABEL: func %main
// IR: switch(%{{.*}}
