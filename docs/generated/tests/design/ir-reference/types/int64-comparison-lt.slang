//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: less-than compare on two Int64 operands yields a cmpLT with Int64 inputs and Bool result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// less-than compare on two Int64 operands yields a cmpLT with Int64
// inputs and Bool result. Comparing two `int64_t` globals produces a
// `cmpLT` with the wider operand type preserved at the IR level.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t a;
uniform int64_t b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (a < b) ? 1 : 0;
}

// IR: {{.*}}: Bool{{.*}}= cmpLT(%a, %b)
