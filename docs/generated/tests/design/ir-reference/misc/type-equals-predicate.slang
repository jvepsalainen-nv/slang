//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#type-queries-and-predicates
//META: purpose=`__type_equals<T, U>()` emits a two-operand `TypeEquals` inst that folds to `true` only when the two queried types are the same.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both halves of the type-equality query: the inst exists in the IR
// while the queried types are still generic parameters, and it answers
// correctly once they are concrete. The IR directive keeps the query behind a
// generic so `TypeEquals(%a, %b)` survives to the dump; the CPU directive
// instantiates it with a matching and a mismatching pair and writes 1 and 0,
// which can only be produced by the fold agreeing with type identity.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry computeMain
//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

bool sameType<T, U>()
{
    return __type_equals<T, U>();
}

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sameType<int, int>() ? 1 : 0;
    outputBuffer[1] = sameType<int, float>() ? 1 : 0;
}

// IR: = TypeEquals(%{{[A-Za-z0-9_]+}}, %{{[A-Za-z0-9_]+}})

// CHECK: 1
// CHECK: 0
