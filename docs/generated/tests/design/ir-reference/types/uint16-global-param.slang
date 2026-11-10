//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: a scalar UInt16 surfaces as the IR type of a uniform uint16_t global_param.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a scalar UInt16 surfaces as the IR type of a uniform uint16_t
// global_param. A bare `uniform uint16_t` exercises the scalar storage
// form for the narrow unsigned type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint16_t v;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(v);
}

// IR: let {{.*}}%v{{.*}}: UInt16{{.*}}= global_param
