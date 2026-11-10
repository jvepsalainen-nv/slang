//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#func
//META: purpose=Boundary: a zero-parameter void function is typed Func(Void) with no parameter operands.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a zero-parameter void function is typed Func(Void) with no parameter
// operands. The minimal Func is one with no params and Void result; it
// appears as `Func(Void)` with no further operands.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

void doNothing() {}

[numthreads(1, 1, 1)]
void main()
{
    doNothing();
    buf[0] = a;
}

// IR-LABEL: func %doNothing
// IR-SAME: Func(Void)
