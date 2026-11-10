//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#loadresourcedescriptorfromheap
//META: purpose=Indirecting through a `DescriptorHandle<RWStructuredBuffer<T>>` on the HLSL target surfaces the documented `LoadResourceDescriptorFromHeap` opcode in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the bindless resource-descriptor load. A
// `DescriptorHandle<T>` is dereferenced and the loaded resource is
// used, so the handle cannot be folded away; the CHECK finds the
// opcode in the HLSL-targeted dump where the heap is implicit and the
// index is the only operand.

//TEST:SIMPLE(filecheck=IR):-target hlsl -dump-ir -o - -stage compute -entry main

uniform DescriptorHandle<RWStructuredBuffer<float4>> buffer;
uniform DescriptorHandle<StructuredBuffer<float4>> src;
uniform RWStructuredBuffer<float4> sink;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    (*buffer)[idx] = (*src)[idx];
    sink[idx] = (*buffer)[idx];
}

// IR: LoadResourceDescriptorFromHeap
