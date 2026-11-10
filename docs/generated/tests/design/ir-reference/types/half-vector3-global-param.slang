//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with Half to form Vec(Half, 3 : Int) on a global_param.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with Half to form Vec(Half, 3 : Int) on a global_param.
// `half3` exercises the three-element shape with the 16-bit floating-
// point element.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half3 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v.x) + float(v.y) + float(v.z);
}

// IR: let {{.*}}%v{{.*}}: Vec(Half, 3 : Int){{.*}}= global_param
