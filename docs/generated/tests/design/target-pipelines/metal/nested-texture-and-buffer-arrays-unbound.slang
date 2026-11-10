//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#resource-type-spellings
//META: purpose=Nested texture arrays and arrays of buffers get no binding attribute: `[[buffer(N)]]` tests the whole parameter type (issue 12291).
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a nested texture array and an array of buffers are emitted with
// no binding attribute (the attribute check inspects the whole parameter
// type for buffers and only one array level for textures). CHECK requires
// each `array<...>` parameter name to be followed directly by `,` or `)`,
// so an attribute between name and delimiter would fail the match.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

Texture2D nested[2][2];
RWStructuredBuffer<float> bufs[2];
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = nested[1][1].Load(int3(0)).x + bufs[1][0];
}

// CHECK: kernel{{.*}} void main_0
// CHECK: array<array<texture2d<float, access::sample>, int(2)>, int(2)> nested_{{[0-9]+}}{{[,)]}}
// CHECK-SAME: array<float device*, int(2)> bufs_{{[0-9]+}}{{[,)]}}
