//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: smallest multi-element vector (float2) is typed Vec(Float, 2 : Int) in the IR.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// smallest multi-element vector (float2) is typed Vec(Float, 2 : Int)
// in the IR. `float2` is the smallest multi-element vector; its IR
// type is `Vec(Float, 2 : Int)`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float2 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.x + v.y;
}

// IR: let {{.*}}%v{{.*}}: Vec(Float, 2 : Int){{.*}}= global_param
