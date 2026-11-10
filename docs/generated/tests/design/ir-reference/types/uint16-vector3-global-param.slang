//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with UInt16 to form Vec(UInt16, 3 : Int) on a global_param.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with UInt16 to form Vec(UInt16, 3 : Int) on a
// global_param. `vector<uint16_t, 3>` exercises the narrow unsigned
// scalar in a three-element vector.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<uint16_t, 3> v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v.x) + uint(v.y) + uint(v.z);
}

// IR: let {{.*}}%v{{.*}}: Vec(UInt16, 3 : Int){{.*}}= global_param
