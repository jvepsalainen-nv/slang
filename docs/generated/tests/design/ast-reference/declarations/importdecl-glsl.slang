//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=An ImportDecl (`import M;`) makes another module's declarations visible in the current file.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `import` resolves and links a real module. The `glsl` module
// ships with the compiler, so the import must succeed for compilation to
// continue; the CHECK asserts the entry point was emitted, which only happens
// after the import resolved.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage compute

import glsl;

//TEST_INPUT: set outBuf = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outBuf;

//CHECK: void main
[shader("compute")]
[numthreads(1,1,1)]
void main()
{
    outBuf[0] = 7;
}
