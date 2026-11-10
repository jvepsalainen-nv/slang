//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=`NewExpr` parses as `'new' Type ('(' ArgList? ')')?` and yields an object whose members are then assignable.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the NewExpr atom in its empty-argument-list form. `slangi` cannot
// instantiate a `class`, so the observation is taken on emitted HLSL instead.
// The object is written to and then read back into the output buffer, which
// keeps the value from being dead-code-eliminated; the store of 21 reaching
// the buffer proves `new Box()` produced a real object rather than being
// parsed as something inert.
//
// The `class` declaration doubles as the ClassDecl production's positive
// case: NewExpr's operand has to be a reference type for the form to apply.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute

class Box
{
    int v;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Box b = new Box();
    b.v = 21;
    outputBuffer[0] = b.v;
}

// CHECK: outputBuffer_{{[0-9]+}}[int(0)] = int(21);
