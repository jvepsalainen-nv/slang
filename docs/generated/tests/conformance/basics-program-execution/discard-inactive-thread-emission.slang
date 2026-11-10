//META: generated=true
//META: doc_ref=docs/language-reference/basics-program-execution.md#wave-execution-model
//META: purpose=The discard statement disables a fragment thread (making it inactive); it emits as discard in HLSL and OpKill in SPIR-V for a fragment entry point.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `discard` in a fragment entry point marks the thread inactive.
// The test compiles a fragment shader with a conditional discard; CHECK confirms
// HLSL emits the `discard` keyword and SPIR-V emits `OpKill`, which are the
// target-specific representations of the thread-deactivation instruction.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=CHECK-SPV):-target spirv-asm -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=CHECK-GLSL):-target glsl -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=CHECK-METAL):-target metal -entry fragMain -stage fragment
//TEST:SIMPLE(filecheck=CHECK-WGSL):-target wgsl -entry fragMain -stage fragment

float4 fragMain(float4 pos : SV_Position) : SV_Target
{
    if (pos.x < 0.0)
        discard;
    return float4(1.0, 0.0, 0.0, 1.0);
}

// HLSL emits the discard statement.
// CHECK: discard

// SPIR-V emits OpKill (the SPIR-V discard operation for fragment shaders).
// CHECK-SPV: OpKill

// GLSL emits the discard keyword in the fragment shader.
// CHECK-GLSL: discard

// Metal emits discard_fragment() (the Metal fragment-discard intrinsic).
// CHECK-METAL: discard_fragment

// WGSL emits the discard statement in the fragment shader.
// CHECK-WGSL: discard
