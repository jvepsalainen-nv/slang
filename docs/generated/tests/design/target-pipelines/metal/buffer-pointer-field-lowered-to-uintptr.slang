//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#metals-three-lowerbufferelementtypetostoragetype-invocations
//META: purpose=The late Metal-only `MetalPointerLowering` invocation converts a pointer field inside a buffer element type to `UIntPtr` (MSL `ulong`) so no `device T* device*` survives.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third invocation exists and is distinct from the other two:
// Metal rejects pointer-to-pointer in buffer element types, so a pointer
// field has to be stored as an integer address instead. The kernel copies
// a whole element (value plus pointer field) through the buffer so the
// field escapes to memory; CHECK asserts `ulong` storage appears and that
// no `device* device*` shape is emitted.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

struct Node
{
    float value;
    float* next;
}

RWStructuredBuffer<Node> nodes;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Node n = nodes[tid.x];
    n.value = n.value + 1.0;
    nodes[tid.x + 1] = n;
}

// CHECK: ulong
// CHECK-NOT: device* device*
