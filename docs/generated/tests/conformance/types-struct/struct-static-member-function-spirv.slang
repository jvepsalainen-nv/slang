//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/language-reference/types-struct.md#static-member-function
//META: doc_section_digest=8afbecf75d617dcea4fff9698c69139804aa496835e7f4949f20e79ddf202cec
//META: purpose=A static member function may be invoked without an object instance; it emits as a free function (no this parameter) in HLSL output.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V fan-out for the sibling struct-static-member-function test. `getB` takes a
// runtime `seed` so the call cannot constant-fold, and the module is emitted at -O0
// to keep the callee from being inlined away. SPV pins the emitted free function
// named "TestStruct.getB" and the `OpFunctionCall` to it; the function has exactly
// one `OpFunctionParameter` (the `seed`), confirming no hidden `this` parameter is
// passed to a static member function.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute -O0

struct TestStruct
{
    static int getB(int seed)
    {
        return seed + 5;
    }
}

RWStructuredBuffer<int> output;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    output[tid.x] = TestStruct.getB(int(tid.x));
}

// SPV-DAG: OpName %TestStruct_getB "TestStruct.getB"
// SPV-DAG: OpFunctionCall %int %TestStruct_getB %{{[0-9]+}}
// SPV-DAG: %TestStruct_getB = OpFunction %int None %{{[0-9]+}}
// The static member has a single parameter (the seed) and no `this`.
// SPV-DAG: %seed = OpFunctionParameter %int
