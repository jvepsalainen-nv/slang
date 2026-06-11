//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#core-module-supplied-vocabulary
//META: doc_section_digest=a84f2b8e553f246fd0e2611d7bd357de1ceb312fa259d862c4056388b6d6a68a
//META: purpose=`StructuredBuffer<T>` is an HLSL-flavored type supplied by `hlsl.meta.slang`; it survives into the emitted HLSL text.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission fan-out for the `StructuredBuffer<T>` claim onto the
// remaining shader text targets. The sibling
// `builtin-hlsl-structured-buffer.slang` pins the HLSL emit; here the
// same read-only-buffer + read-write-buffer program is lowered to GLSL,
// Metal, SPIR-V, and WGSL, and each CHECK pins the target's own
// distinguishing form of a read-only structured buffer (GLSL `readonly
// buffer`, Metal `device` pointer, SPIR-V `NonWritable` decoration, WGSL
// `var<storage, read>`) so the per-target lowering of the type is
// observed, not just HLSL.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

StructuredBuffer<int> inBuf;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    outBuf[0] = inBuf[0] + 1;
}

// GLSL lowers the read-only StructuredBuffer to a `readonly buffer` block.
//GLSL: readonly buffer
// Metal lowers it to a `device` address-space pointer parameter.
//METAL: int device* inBuf
// SPIR-V keeps the type name and marks the read-only buffer NonWritable.
//SPV-DAG: OpName %StructuredBuffer "StructuredBuffer"
//SPV-DAG: OpDecorate %inBuf NonWritable
// WGSL lowers the read-only StructuredBuffer to a read-only storage var.
//WGSL: var<storage, read> inBuf{{.*}}: array<i32>
