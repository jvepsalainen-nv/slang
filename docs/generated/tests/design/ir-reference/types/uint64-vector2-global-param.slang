//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with UInt64 to form Vec(UInt64, 2 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with UInt64 to form Vec(UInt64, 2 : Int).
// `vector<uint64_t, 2>` surfaces the largest unsigned scalar in a
// minimum-multi-element vector.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<uint64_t, 2> v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v.x) + uint(v.y);
}

// IR: let {{.*}}%v{{.*}}: Vec(UInt64, 2 : Int){{.*}}= global_param
