//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Boundary: largest signed-integer scalar (Int64) appears alone on a global_param's IR type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// largest signed-integer scalar (Int64) appears alone on a
// global_param's IR type. A single `uniform int64_t` exercises the
// largest-edge boundary.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t v;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(v);
}

// IR: let {{.*}}%v{{.*}}: Int64{{.*}}= global_param
