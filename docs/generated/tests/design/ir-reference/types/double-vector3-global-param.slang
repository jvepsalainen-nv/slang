//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with Double to form Vec(Double, 3 : Int) on a global_param.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with Double to form Vec(Double, 3 : Int) on a
// global_param. `double3` exercises the three-element shape with the
// 64-bit floating-point element.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double3 v;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.x + v.y + v.z;
}

// IR: let {{.*}}%v{{.*}}: Vec(Double, 3 : Int){{.*}}= global_param
