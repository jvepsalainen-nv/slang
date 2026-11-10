//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=Member lookup auto-dereferences a pointer-like ConstantBuffer before the type dispatch, so a field of the pointee is reachable through a Deref navigation step.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the auto-dereference that runs ahead of the per-type
// dispatch. `cb` has type ConstantBuffer<Params>, which declares no
// member named `a`; the access only resolves if lookup first stepped
// through the pointee. INTERPRET cannot host a ConstantBuffer global,
// so the observation is the emitted HLSL: CHECK asserts the read is
// rendered as a field access on the buffer.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry main

struct Params { float a; }

ConstantBuffer<Params> cb;

RWStructuredBuffer<float> outBuf;

[numthreads(1,1,1)]
void main()
{
    // CHECK: cb_{{[0-9]+}}.a_{{[0-9]+}}
    outBuf[0] = cb.a;
}
