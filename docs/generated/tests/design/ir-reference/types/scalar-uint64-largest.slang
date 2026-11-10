//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Boundary: largest unsigned-integer scalar (UInt64) appears alone on a global_param's IR type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// largest unsigned-integer scalar (UInt64) appears alone on a
// global_param's IR type. A single `uniform uint64_t` exercises the
// unsigned largest-edge boundary.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint64_t v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v);
}

// IR: let {{.*}}%v{{.*}}: UInt64{{.*}}= global_param
