//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array composes with the narrow Int8 element type, surfacing Array(Int8, N : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array composes with the narrow Int8 element type, surfacing
// Array(Int8, N : Int). An `int8_t[4]` global_param surfaces
// `Array(Int8, 4 : Int)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int8_t v[4];
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(v[0]) + int(v[3]);
}

// IR: let {{.*}}%v{{.*}}: Array(Int8, 4 : Int){{.*}}= global_param
