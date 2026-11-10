//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#rates-and-rate-qualified-types
//META: purpose=A groupshared declaration is typed RateQualified(GroupShared, Ptr(<T>)) in the IR.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A groupshared declaration is typed RateQualified(GroupShared,
// Ptr(<T>)) in the IR. A `groupshared int gs;` declaration surfaces
// `RateQualified(GroupShared, Ptr(Int))` as its IR type in the
// `global_var` declaration of `gs`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

groupshared int gs;
uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0) gs = a;
    GroupMemoryBarrierWithGroupSync();
    buf[tid.x] = gs;
}

// IR: global_var %gs {{.*}} RateQualified(GroupShared, Ptr(Int))
