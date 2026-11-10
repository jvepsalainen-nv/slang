//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeirformetal
//META: purpose=`legalizeFuncBody` rewrites a call argument that takes the address of a vector element into a temporary with copy-in/copy-out, because Metal cannot take the address of a vector element.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Passing `v.y` to an `inout` parameter would need the address of a vector
// element, which MSL forbids. The Metal legalizer copies the element into a
// temporary, passes the temporary's address, and stores it back afterwards.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<float4> o;

void bump(inout float x)
{
    x += 1.0f;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float4 v = float4(1, 2, 3, 4);
    bump(v.y);
    o[0] = v;
}

// CHECK: thread float [[TMP:_S[0-9]+]] = v_{{[0-9]+}}.y;
// CHECK: bump_{{[0-9]+}}(&[[TMP]]);
// CHECK: v_{{[0-9]+}}.y = [[TMP]];
// CHECK-NOT: &v_{{[0-9]+}}.y
