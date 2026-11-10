//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#functions-and-generics
//META: purpose=A call to a zero-parameter function emits a call whose operand list is the callee alone, with an empty argument tail.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Exercises the low end of the `call` operand-count axis: the variadic argument
// tail can be empty. `readSeed()` declares no parameters but reads a uniform, so
// it is neither folded nor given a hidden argument; CHECK requires the emitted
// call to print as `call %readSeed()` with nothing between the parentheses.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int seed;
uniform RWStructuredBuffer<int> buf;

int readSeed()
{
    return seed + 1;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = readSeed();
}

// CHECK: func %readSeed	: Func(Int)
// CHECK-LABEL: func %main
// CHECK: call %readSeed()
