//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: minimum-dimension vector (vector<float,1>) is typed Vec(Float, 1 : Int) in the IR.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// minimum-dimension vector (vector<float,1>) is typed Vec(Float, 1 :
// Int) in the IR. The smallest documented elementCount is `1`; a
// `uniform vector<float,1>` surfaces `Vec(Float, 1 : Int)` in the
// dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform vector<float, 1> v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.x;
}

// IR: let {{.*}}%v{{.*}}: Vec(Float, 1 : Int){{.*}}= global_param
