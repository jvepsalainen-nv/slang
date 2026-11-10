//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with the wide Int64 scalar to form Vec(Int64, 2 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with the wide Int64 scalar to form Vec(Int64, 2 : Int).
// `vector<int64_t, 2>` exercises the largest documented signed scalar
// inside a vector.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<int64_t, 2> v;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(v.x) + int(v.y);
}

// IR: let {{.*}}%v{{.*}}: Vec(Int64, 2 : Int){{.*}}= global_param
