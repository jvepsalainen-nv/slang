//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of Half elements surfaces Array(Half, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of Half elements surfaces Array(Half, N : Int) in the IR dump.
// A `half[4]` global_param surfaces `Array(Half, 4 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half v[4];
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v[0]) + float(v[3]);
}

// IR: let {{.*}}%v{{.*}}: Array(Half, 4 : Int){{.*}}= global_param
