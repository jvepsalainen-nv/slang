//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Boundary: largest floating-point scalar (Double, 64-bit) appears alone on a global_param's IR type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// largest floating-point scalar (Double, 64-bit) appears alone on a
// global_param's IR type. A single `uniform double` exercises the
// largest-edge floating-point boundary.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(v);
}

// IR: let {{.*}}%v{{.*}}: Double{{.*}}= global_param
