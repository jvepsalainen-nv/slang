//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Expansion: Vec composes with the wide Double scalar to form Vec(Double, 2 : Int).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Vec composes with the wide Double scalar to form Vec(Double, 2 :
// Int). A `double2` surfaces `Vec(Double, 2 : Int)` on a global_param.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double2 v;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.x + v.y;
}

// IR: let {{.*}}%v{{.*}}: Vec(Double, 2 : Int){{.*}}= global_param
