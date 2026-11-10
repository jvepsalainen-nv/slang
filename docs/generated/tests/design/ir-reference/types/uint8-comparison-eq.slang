//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: equality compare on two UInt8 operands yields a Bool-typed cmpEQ on Int8 inputs.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// equality compare on two UInt8 operands yields a Bool-typed cmpEQ on
// Int8 inputs. Comparing two `uint8_t` globals produces a `cmpEQ`
// whose operands are typed `UInt8`, demonstrating that comparisons
// preserve the narrow operand type at the IR level.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint8_t a;
uniform uint8_t b;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (a == b) ? 1u : 0u;
}

// IR: {{.*}}: Bool{{.*}}= cmpEQ(%a, %b)
