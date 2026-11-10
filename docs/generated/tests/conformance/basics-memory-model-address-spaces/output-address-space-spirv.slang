//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=Entry-point output parameters and return values belong to the Output address space; SPIRV emits vertex shader outputs with `Output` storage class.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that entry-point output values (return value fields and out parameters) map to
// the Output address space. A vertex shader returns a struct carrying `SV_Position` and
// `TEXCOORD0`; CHECK asserts the SPIRV declares at least one `OpVariable ... Output`,
// confirming the Output address-space-to-storage-class mapping for stage outputs.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry vsMain -stage vertex
//TEST:SIMPLE(filecheck=METAL):-target metal -entry vsMain -stage vertex
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry vsMain -stage vertex
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry vsMain -stage vertex
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry vsMain -stage vertex

struct VSOutput {
    float4 pos : SV_Position;
    float2 uv  : TEXCOORD0;
};

VSOutput vsMain(float3 pos : POSITION, float2 uv : TEXCOORD0)
{
    VSOutput o;
    o.pos = float4(pos, 1.0);
    o.uv  = uv;
    return o;
}

// Vertex shader output (SV_Position and TEXCOORD0 output) use Output storage class.
// CHECK: OpVariable {{.*}} Output
// Metal emits the vertex entry point with the [[vertex]] attribute and output fields with [[position]].
// METAL-DAG: vertex
// METAL-DAG: position
// WGSL emits @vertex and output struct field with @builtin(position).
// WGSL-DAG: @vertex
// WGSL-DAG: @builtin(position)
// GLSL maps Output-address-space values to `out` varyings and the gl_Position builtin.
// GLSL: out vec2 entryPointParam_vsMain_uv_
// GLSL: gl_Position =
// HLSL keeps them as semantic-annotated fields of the returned struct.
// HLSL: float4 pos_{{.*}} : SV_Position;
// HLSL: float2 uv_{{.*}} : TEXCOORD0;
// HLSL: VSOutput_{{[0-9]+}} vsMain(
