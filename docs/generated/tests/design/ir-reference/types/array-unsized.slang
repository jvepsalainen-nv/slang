//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#array-vs-unsizedarray
//META: purpose=An unsized array (runtime extent) is typed UnsizedArray(elementType) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An unsized array (runtime extent) is typed UnsizedArray(elementType)
// in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float tail[];
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = tail[0];
}

// IR: let {{.*}}%tail{{.*}}: UnsizedArray(Float){{.*}}= global_param
