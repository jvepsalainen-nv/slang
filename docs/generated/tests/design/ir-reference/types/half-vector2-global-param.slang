//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with the narrow Half float scalar to form Vec(Half, 2 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with the narrow Half float scalar to form Vec(Half, 2 :
// Int). A `half2` global surfaces `Vec(Half, 2 : Int)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half2 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v.x) + float(v.y);
}

// IR: let {{.*}}%v{{.*}}: Vec(Half, 2 : Int){{.*}}= global_param
