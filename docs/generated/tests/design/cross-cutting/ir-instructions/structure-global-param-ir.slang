//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#function-and-module-structure
//META: purpose=A module-scope shader parameter lowers to a `global_param` inst.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `global_param` structure row ("Module-scope storage
// / parameters"). The module-scope `RWStructuredBuffer` shader parameter
// appears as a `global_param` inst in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 7;
}

// IR: global_param
