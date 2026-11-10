//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#shader-io
//META: purpose=A module-scope `ByteAddressBuffer` declaration surfaces a `global_param` with the bare `ByteAddressBuffer` resource type, with no element-type parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a byte-address buffer parameter carries its type
// directly on the `global_param`, with no element-type parameterization
// in parentheses. Both the read-only and the writable spelling are
// declared so the CHECKs can pin each bare type name separately.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform ByteAddressBuffer babuf;
uniform RWByteAddressBuffer rwbabuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint v = babuf.Load(idx * 4);
    rwbabuf.Store(idx * 4, v + 1);
    rwbuf[idx] = v;
}

// IR: %babuf{{.*}}: ByteAddressBuffer{{.*}}= global_param
// IR: %rwbabuf{{.*}}: RWByteAddressBuffer{{.*}}= global_param
