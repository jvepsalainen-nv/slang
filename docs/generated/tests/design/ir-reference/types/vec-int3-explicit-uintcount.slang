//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: a int3 vector type combines the signed-int scalar with elementCount 3 in the Vec opcode.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a int3 vector type combines the signed-int scalar with elementCount
// 3 in the Vec opcode. Pairing a signed `Int` scalar with elementCount
// 3 surfaces `Vec(Int, 3 : Int)` — distinct from the existing
// `Vec(UInt, 3 : Int)` covered by the smoke test.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int3 v;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.x + v.y + v.z;
}

// IR: let {{.*}}%v{{.*}}: Vec(Int, 3 : Int){{.*}}= global_param
