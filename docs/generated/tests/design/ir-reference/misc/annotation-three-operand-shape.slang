//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#annotation
//META: purpose=Every `Annotation` is built with three operands — the annotated inst, an `AnnotationKind` stored as a `uint` literal, and the annotation value — so one target can carry several annotations keyed by kind.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the operand shape that makes annotations retrievable by key rather
// than by position. A `[Differentiable]` function pulls in the forward-mode
// autodiff pass, which is what attaches the differential-type annotations; the
// CHECK requires the middle operand of an annotation over `Float` to be a bare
// `uint` literal, and the two CHECK-DAG lines require two annotations with
// *different* kind values over that same target, which is only meaningful if
// the kind operand is the key.

//TEST:SIMPLE(filecheck=IR):-target hlsl -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<float> outputBuffer;

[Differentiable]
float f(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    var dp = diffPair(3.0f, 1.0f);
    outputBuffer[0] = __fwd_diff(f)(dp).d;
}

// IR-DAG: Annotation(Float, 14 : UInt, %{{[A-Za-z0-9_]+}})
// IR-DAG: Annotation(Float, 15 : UInt, %{{[A-Za-z0-9_]+}})
