//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with Half to form Vec(Half, 4 : Int) at the standard upper element count.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with Half to form Vec(Half, 4 : Int) at the standard
// upper element count. `half4` exercises the standard upper element
// count with the narrow floating-point element.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half4 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v.x) + float(v.w);
}

// IR: let {{.*}}%v{{.*}}: Vec(Half, 4 : Int){{.*}}= global_param
