//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#specializeaddressspaceformetal
//META: purpose=Structured-buffer storage pointers carry Metal's `device` address space while uniform/constant-buffer pointers carry `constant`, both assigned by `specializeAddressSpaceForMetal`.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two non-threadgroup spaces at once. The abstract
// storage-buffer address space has no Metal equivalent, so buffer-element
// pointers must be mapped onto `device`, while the uniform context pointer
// belongs in `constant`. A shader that reads a uniform and writes a
// structured buffer keeps both pointers live; CHECK asserts the `device`
// qualifier on the element pointer type and a `constant*` parameter.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

uniform int scale;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) * scale;
}

// CHECK: int device*
// CHECK: constant*
