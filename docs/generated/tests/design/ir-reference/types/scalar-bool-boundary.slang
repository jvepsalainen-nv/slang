//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Boundary: smallest documented scalar (Bool, single bit) appears as a global_param's IR type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// smallest documented scalar (Bool, single bit) appears as a
// global_param's IR type. A `uniform bool` declaration in isolation
// surfaces `Bool` directly on the `global_param` IR instruction, with
// no widening or struct wrap.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool flag;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = flag ? 1 : 0;
}

// IR: let {{.*}}%flag{{.*}}: Bool{{.*}}= global_param
