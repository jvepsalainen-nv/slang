//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#tuples-packs-and-target-tuples
//META: purpose=Calling a variadic generic produces a value of IR type TypePack(types...) holding one operand per pack element.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A variadic-generic type pack has its own IR type opcode whose operand
// list is the pack's element types, in order. A `sum<each T : IInteger>`
// helper is called with three int arguments; the IR dump is FileChecked
// for the argument pack value typed `TypePack(Int, Int, Int)` produced by
// makeValuePack, so the arity of the call site is what determines the
// operand count of the pack type.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage compute -entry main -dump-ir -o -

RWStructuredBuffer<int> outputBuffer;

int sum<each T : IInteger>(expand each T vals)
{
    int r = 0;
    expand r += int((each vals).toInt());
    return r;
}

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = sum(1, 2, 3);
}

// IR: TypePack(Int, Int, Int){{.*}}= makeValuePack(1 : Int, 2 : Int, 3 : Int)
