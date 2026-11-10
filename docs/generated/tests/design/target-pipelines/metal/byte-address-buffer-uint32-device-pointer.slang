//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-c-metal-legalization-lowering-phi-elimination
//META: purpose=A byte-address buffer is emitted as a `uint32_t device*` and a surviving load indexes it by word, as `as_type<T>(buf[(offset)>>2])`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the emitted consequence of the Metal byte-address option set:
// because the lowering leaves only 4-byte word accesses behind, the buffer
// itself is a pointer to 32-bit words and the user's byte offset has to be
// shifted down by two before it can index that pointer. The CHECK pins the
// pointer spelling on the parameter and the shift inside the subscript,
// which together are what makes the byte-to-word conversion observable.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

ByteAddressBuffer src;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = src.Load(tid.x * 4);
}

// CHECK: uint32_t device* src_{{[0-9]+}} {{\[\[}}buffer({{[0-9]+}}){{\]\]}}
// CHECK: as_type<uint>(src_{{[0-9]+}}[{{.*}}>>2])
