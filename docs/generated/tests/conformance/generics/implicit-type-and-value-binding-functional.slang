//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#implicit-parameter-binding-for-type-and-value
//META: purpose=Both a type parameter and a value parameter are inferred implicitly from a fixed-size array argument.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's "Implicit parameter binding for type and value" example:
// `sumElements<ElementType : IArithmetic, let N : uint>(ElementType arr[N])`
// is called with an `int[7]` literal, so both ElementType=int and N=7 are
// inferred from the single array argument. CHECK asserts the sum 1..7 == 28,
// proving type and value parameters were inferred together from the array.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

func sumElements<ElementType : IArithmetic, let N : uint>(ElementType arr[N]) -> ElementType
{
    ElementType acc = arr[0];
    for (uint i = 1; i < N; ++i)
        acc = acc + arr[i];
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int elements[7] = { 1, 2, 3, 4, 5, 6, 7 };
    outputBuffer[0] = sumElements(elements);
}
// CHECK: 28
