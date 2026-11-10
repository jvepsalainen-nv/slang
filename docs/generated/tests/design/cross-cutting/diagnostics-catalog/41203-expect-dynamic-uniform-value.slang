//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E41203 (expect-dynamic-uniform-value) - value must be dynamic uniform
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: catalog_code=41203
//META: catalog_name=expect-dynamic-uniform-value
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Writing a per-thread value into a `dynamic_uniform` struct field
// triggers the uniformity-store warning under -validate-uniformity.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -profile cs_6_0 -validate-uniformity

RWStructuredBuffer<int> output;

struct B { dynamic_uniform int d; }
ConstantBuffer<B> ub;

void main(int tid : SV_DispatchThreadID) {
    B obj = ub;
    obj.d = tid;
    output[0] = obj.d;
}

//CHECK: E41203
