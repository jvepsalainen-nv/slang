//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=Metal `[[buffer(N)]]` indices are assigned positionally in declaration order rather than from HLSL `register()` or Vulkan `vk::binding`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positional binding rule with three buffers. The emitted
// parameter order is not the declaration order -- the read-write buffer is
// listed first -- so this also pins that the *index* follows declaration
// order while the *parameter position* does not. CHECK matches the kernel
// signature and then, on the same line, the slot markers in the order they
// are emitted: 2, 0, 1.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

StructuredBuffer<int> a;
StructuredBuffer<int> b;
RWStructuredBuffer<int> c;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    c[tid.x] = a[tid.x] + b[tid.x];
}

// CHECK: kernel{{.*}} void main_0
// CHECK-SAME: buffer(2)
// CHECK-SAME: buffer(0)
// CHECK-SAME: buffer(1)
