//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=HLSL emission pin: `a + b * c` emits with `*` nested inside `+`, confirming the parser groups `*` before `+`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission test: verify that every text-emit back-end emits `a + b * c`
// preserving the `*`-inside-`+` grouping. The operands are read from a
// buffer so constant folding and DCE cannot eliminate the expression, and
// the emitted statement must therefore still show the multiply as an
// operand of the add. Precedence is resolved by the parser, but the
// *shape* of the emitted expression is what each back-end writes out, so
// the claim is pinned on every back-end separately.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int a = outputBuffer[0];
    int b = outputBuffer[1];
    int c = outputBuffer[2];
    outputBuffer[3] = a + b * c;
}

// Each source-emitting back-end must write the assignment with the multiply
// as the right-hand operand of the add. The patterns are deliberately tight
// on the operator shape and wild on the generated buffer suffix and the
// index spelling: requiring the first operand to follow `= ` directly is
// what rules out the wrong grouping, because `(a + b) * c` would emit an
// open parenthesis there instead.

// HLSL: {{= outputBuffer[A-Za-z0-9_]*\[.*\] \+ outputBuffer[A-Za-z0-9_]*\[.*\] \* outputBuffer[A-Za-z0-9_]*\[.*\];}}

// GLSL: {{= outputBuffer[A-Za-z0-9_]*\._data\[.*\] \+ outputBuffer[A-Za-z0-9_]*\._data\[.*\] \* outputBuffer[A-Za-z0-9_]*\._data\[.*\];}}

// Metal lowers the structured buffer to a raw pointer, so each element read
// emits as `*(outputBuffer_N + index)`.
// METAL: {{= \*\(outputBuffer[A-Za-z0-9_]*\+.*\) \+ \*\(outputBuffer[A-Za-z0-9_]*\+.*\) \* \*\(outputBuffer[A-Za-z0-9_]*\+.*\);}}

// WGSL: {{= outputBuffer[A-Za-z0-9_]*\[.*\] \+ outputBuffer[A-Za-z0-9_]*\[.*\] \* outputBuffer[A-Za-z0-9_]*\[.*\];}}

// SPIR-V has no expression nesting, so the grouping shows up as data flow:
// the `OpIMul` of `b` and `c` is what feeds the `OpIAdd` with `a`.
// SPIRV: %[[MUL:[0-9]+]] = OpIMul %int %b %c
// SPIRV: %{{[0-9]+}} = OpIAdd %int %a %[[MUL]]
