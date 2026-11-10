//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#discard-statement
//META: purpose=discard in a fragment shader emits a discard instruction in the target output.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the discard statement compiles and emits a discard/kill on every
// shader text target. discard is valid only in fragment shaders; this test targets
// pixel-shader compilation.
//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=SPVCHECK):-target spirv-asm -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=METAL):-target metal -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry fragMain -stage fragment

float4 fragMain(float4 color : COLOR) : SV_Target
{
    if (color.a < 0.1)
        discard;
    return color;
}

// HLSL should emit discard
// CHECK: discard
// SPIR-V should emit OpKill or OpTerminateInvocation
// SPVCHECK: OpKill

// GLSL spells the same statement `discard;` inside the guarded branch.
// GLSL: void main()
// GLSL: discard;

// Metal has no `discard` keyword; the statement lowers to the
// metal_stdlib intrinsic discard_fragment().
// METAL: {{\[\[}}fragment{{\]\]}} pixelOutput_0 fragMain
// METAL: discard_fragment();

// WGSL spells it `discard;` as well.
// WGSL: fn fragMain
// WGSL: discard;
