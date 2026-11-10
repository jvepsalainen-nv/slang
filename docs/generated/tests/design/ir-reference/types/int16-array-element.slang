//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of Int16 elements surfaces Array(Int16, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of Int16 elements surfaces Array(Int16, N : Int) in the IR
// dump. An `int16_t[5]` global_param surfaces `Array(Int16, 5 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int16_t v[5];
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(v[0]) + int(v[4]);
}

// IR: let {{.*}}%v{{.*}}: Array(Int16, 5 : Int){{.*}}= global_param
