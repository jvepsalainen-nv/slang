//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of Int64 elements surfaces Array(Int64, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of Int64 elements surfaces Array(Int64, N : Int) in the IR
// dump. An `int64_t[3]` global_param surfaces `Array(Int64, 3 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t v[3];
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(v[0]) + int(v[2]);
}

// IR: let {{.*}}%v{{.*}}: Array(Int64, 3 : Int){{.*}}= global_param
