//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=`Declarator` folds a prefix `'*'` onto a `typedef` alias type, so `typedef int* IntPtr;` parses.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the prefix-'*' Declarator form in TypedefDecl: the alias
// must denote pointer-to-int. Writing through a value of the alias
// type mutates the pointee, observable in the output buffer — which
// requires the '*' to have folded onto the alias type.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer

typedef int* IntPtr;

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int x = 41;
    IntPtr p = &x;
    *p = *p + 1;
    // CHECK: 42
    outputBuffer[0] = x;
}
