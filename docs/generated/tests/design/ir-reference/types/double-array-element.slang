//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Expansion: Array of Double elements surfaces Array(Double, N : Int) in the IR dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Array of Double elements surfaces Array(Double, N : Int) in the IR
// dump. A `double[3]` global_param surfaces `Array(Double, 3 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double v[3];
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v[0] + v[2];
}

// IR: let {{.*}}%v{{.*}}: Array(Double, 3 : Int){{.*}}= global_param
