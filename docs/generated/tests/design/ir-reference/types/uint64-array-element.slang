//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of UInt64 elements surfaces Array(UInt64, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of UInt64 elements surfaces Array(UInt64, N : Int) in the IR
// dump. A `uint64_t[2]` global_param surfaces `Array(UInt64, 2 :
// Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint64_t v[2];
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v[0]) + uint(v[1]);
}

// IR: let {{.*}}%v{{.*}}: Array(UInt64, 2 : Int){{.*}}= global_param
