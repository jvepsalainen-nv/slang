//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#runtime-type-information
//META: purpose=A non-default binding index reaches GetDynamicResourceHeap as its literal operand rather than being normalised to zero.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on the binding-index operand, whose default is zero. Requesting
// binding 2 must survive into the inst's operand list; the CHECK pins the
// literal `2 : UInt`, so a dropped or defaulted index would fail.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    let heap = __getDynamicResourceHeap<Texture2D<float4> >(2);
    buf[0] = int(heap[inVal].Load(int3(0, 0, 0)).x);
}

// CHECK: GetDynamicResourceHeap(2 : UInt)
