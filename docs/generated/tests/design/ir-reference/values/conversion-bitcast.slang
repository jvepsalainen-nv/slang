//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=The `bit_cast<T>(...)` builtin lowers to the `bitCast` opcode (reinterpret bits without changing them).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Conversions table lists `bitCast` with AST origin "`BitCastExpr`
// and `__bit_cast` intrinsic". The Slang core-module surface is
// `bit_cast<TargetType>(value)`. A reinterpret of an int's bits as a
// float surfaces the opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<float> fbuf;

[numthreads(1, 1, 1)]
void main()
{
    float g = bit_cast<float>(a);
    fbuf[0] = g;
}

// IR-LABEL: func %main
// IR: bitCast(%a)
