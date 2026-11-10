//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of UInt16 elements surfaces Array(UInt16, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of UInt16 elements surfaces Array(UInt16, N : Int) in the IR
// dump. A `uint16_t[6]` global_param surfaces `Array(UInt16, 6 :
// Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint16_t v[6];
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v[0]) + uint(v[5]);
}

// IR: let {{.*}}%v{{.*}}: Array(UInt16, 6 : Int){{.*}}= global_param
