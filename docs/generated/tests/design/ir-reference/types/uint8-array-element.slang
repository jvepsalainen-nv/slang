//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of UInt8 elements surfaces Array(UInt8, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of UInt8 elements surfaces Array(UInt8, N : Int) in the IR
// dump. A `uint8_t[8]` global_param surfaces `Array(UInt8, 8 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint8_t v[8];
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v[0]) + uint(v[7]);
}

// IR: let {{.*}}%v{{.*}}: Array(UInt8, 8 : Int){{.*}}= global_param
