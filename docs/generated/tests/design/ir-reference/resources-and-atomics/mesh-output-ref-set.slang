//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#mesh-shader-outputs
//META: purpose=A mesh-shader entry point that writes to `out vertices`, `out primitives`, and `out indices` arrays surfaces the documented `meshOutputRef` and `meshOutputSet` opcodes in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two mesh output-array accessors. Writing one field of a
// vertex goes through the `ref` accessor and yields the reference
// opcode; assigning a whole element goes through the `set` accessor and
// yields the write opcode. Both CHECKs are order-independent because
// the two array writes are independent.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage mesh -entry main

struct MeshVertex
{
    float4 pos : SV_Position;
    float3 color : COLOR;
};

struct MeshPrim
{
    uint primId : SV_PrimitiveID;
};

[shader("mesh")]
[outputtopology("triangle")]
[numthreads(3, 1, 1)]
void main(
    uint tid : SV_DispatchThreadID,
    out indices uint3 triangles[1],
    out vertices MeshVertex verts[3],
    out primitives MeshPrim prims[1])
{
    SetMeshOutputCounts(3, 1);
    if (tid < 3)
    {
        verts[tid].pos = float4(float(tid), 0.0, 0.0, 1.0);
        verts[tid].color = float3(float(tid), 1.0, 0.0);
    }
    if (tid == 0)
    {
        triangles[0] = uint3(0, 1, 2);
        prims[0].primId = 42;
    }
}

// IR-DAG: meshOutputRef
// IR-DAG: meshOutputSet
