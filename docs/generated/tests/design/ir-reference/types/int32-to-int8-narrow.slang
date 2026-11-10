//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: narrowing conversion from Int to Int8 yields a value typed Int8 in the dump.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// narrowing conversion from Int to Int8 yields a value typed Int8 in
// the dump. An `int8_t(v)` narrowing produces a value of IR type
// `Int8`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int v;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int8_t narrowed = int8_t(v);
    buf[0] = int(narrowed);
}

// IR: let {{.*}}%narrowed{{.*}}: Int8{{.*}}= {{.*}}Cast
