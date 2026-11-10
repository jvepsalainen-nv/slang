//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Boundary: largest-element vector (double4) is typed Vec(Double, 4 : Int) in the IR.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// largest-element vector (double4) is typed Vec(Double, 4 : Int) in
// the IR. Combining the largest documented scalar (`Double`) with the
// standard upper element count (4) surfaces `Vec(Double, 4 : Int)` in
// the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double4 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v.x);
}

// IR: let {{.*}}%v{{.*}}: Vec(Double, 4 : Int){{.*}}= global_param
