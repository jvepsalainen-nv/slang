//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#string-hashing
//META: purpose=A call to the core-module `getStringHash(String)` lowers to a `getStringHash` inst whose single operand is the string literal itself.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the hash inst keeps the literal as its operand rather than a
// pre-computed number, which is what lets a later stage compute a stable hash
// of the literal's bytes. Two helpers hash two different literals; each CHECK
// is anchored at its own helper and quotes the literal text inside the inst,
// so an operand that had already been folded to an integer would not match.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<uint> outputBuffer;

uint helperA() { return getStringHash("hello-world"); }
uint helperB() { return getStringHash("slang-misc"); }

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = helperA();
    outputBuffer[1] = helperB();
}

// IR-LABEL: func %helperA
// IR: getStringHash("hello-world")
// IR-LABEL: func %helperB
// IR: getStringHash("slang-misc")
