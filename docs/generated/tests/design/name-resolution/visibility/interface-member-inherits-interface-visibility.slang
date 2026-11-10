//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=An unmodified interface requirement inherits the interface's visibility at every language version, so an `internal` interface's requirement is accepted even when the module default is `public`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the interface-member fall-through, and that it is not gated on
// Slang 2026 the way the aggregate rule is. The module default is `public`
// (the module is marked `public`) and the file is compiled as 2025, where
// aggregate members do fall back to that default. The only unmodified decl
// here is the requirement `int sides();` inside an `internal` interface;
// every implementing member is annotated explicitly. Compiling clean shows
// the requirement took `internal` from `IShape` rather than the module
// default, which would have been higher than its parent.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -std 2025 -entry computeMain -stage compute

public module interfaceMemberInheritsVisibility;

internal interface IShape
{
    int sides();
}

internal struct Triangle : IShape
{
    internal int sides() { return 3; }
}

internal int sidesOf<T : IShape>(T shape) { return shape.sides(); }

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sidesOf(Triangle());
}

// CHECK: outputBuffer_{{[0-9]+}}[int(0)] = sidesOf_
