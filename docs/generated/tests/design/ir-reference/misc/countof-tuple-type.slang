//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#size-alignment-count
//META: purpose=`countof` accepts a tuple and yields its element count, folded by `maybeSpecializeCountOf` once the operand is a tuple type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the tuple half of the count query's domain. Two tuples of different
// arity are counted, so the asserted 3 / 2 sequence shows a real per-tuple
// element count.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Tuple<int, float, uint> three = makeTuple(1, 2.0f, 3u);
    Tuple<int, float> two = makeTuple(1, 2.0f);
    outputBuffer[0] = countof(three);
    outputBuffer[1] = countof(two);
}

// CHECK: {{^3$}}
// CHECK-NEXT: 2
