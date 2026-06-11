//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:23:45+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/expressions-identifier.md#overloading
//META: doc_section_digest=9484a135a7d65023e550053886ef224a8110c3717ecb4a6f046fb51a7be6e355
//META: purpose=Overload disambiguation is reflected in emitted HLSL as distinct mangled function names for each resolved overload.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the overload-disambiguation claim (HLSL sibling pins it on HLSL).
// The two `probe` overloads resolve by argument type; on each target the compiler emits
// two distinct mangled function definitions (one taking the int param, one the float param),
// proving the two overloads were resolved to separate specializations. Each CHECK pins the
// per-target signature of each emitted definition. The spirv-asm target is NOT fanned out:
// SPIR-V inlines and constant-folds both trivial calls (the result reduces to OpIAdd of two
// constants), so no distinct function definitions survive to observe (see Untested row).
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

int probe(int x)   { return 1; }
int probe(float x) { return 2; }

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void computeMain()
{
    int ri = probe(int(3));
    int rf = probe(float(3));
    outBuf[0] = ri + rf;
}

// GLSL emits two distinct probe definitions distinguished by parameter type.
// GLSL-DAG: int probe_{{[0-9]+}}(int
// GLSL-DAG: int probe_{{[0-9]+}}(float

// Metal emits two distinct probe definitions distinguished by parameter type.
// METAL-DAG: int probe_{{[0-9]+}}(int
// METAL-DAG: int probe_{{[0-9]+}}(float

// WGSL emits two distinct probe definitions distinguished by parameter type.
// WGSL-DAG: fn probe_{{[0-9]+}}( {{[A-Za-z_0-9]+}} : i32)
// WGSL-DAG: fn probe_{{[0-9]+}}( {{[A-Za-z_0-9]+}} : f32)
