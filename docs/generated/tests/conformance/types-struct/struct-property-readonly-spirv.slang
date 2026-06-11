//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#property
//META: doc_section_digest=2be36ef488309471e001ccf502f4e364705629af21bac8d6137274483b7c4b14
//META: purpose=A property that provides only a `get` accessor is read-only; assigning to it is a compile error.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-property-readonly test. The get-only property
// `xVal` reads `m_x` (fed from a runtime thread id so it cannot fold); the module is
// emitted at -O0 to keep the accessor from being inlined away. SPV pins the emitted
// get-accessor free function "ReadOnlyProp.xVal.get", the `OpFunctionCall` to it, and
// the backing struct member "m_x", proving the read-only property's get accessor wires
// through to SPIR-V emission.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute -O0

struct ReadOnlyProp
{
    int m_x;

    property xVal : int
    {
        get { return m_x + 1; }
    }
}

RWStructuredBuffer<int> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    ReadOnlyProp obj;
    obj.m_x = int(tid.x);
    output[tid.x] = obj.xVal;
}

// SPV-DAG: OpName %ReadOnlyProp "ReadOnlyProp"
// SPV-DAG: OpMemberName %ReadOnlyProp 0 "m_x"
// SPV-DAG: OpName %ReadOnlyProp_xVal_get "ReadOnlyProp.xVal.get"
// SPV-DAG: OpFunctionCall %int %ReadOnlyProp_xVal_get %{{[0-9]+}}
// SPV-DAG: %ReadOnlyProp_xVal_get = OpFunction %int None %{{[0-9]+}}
