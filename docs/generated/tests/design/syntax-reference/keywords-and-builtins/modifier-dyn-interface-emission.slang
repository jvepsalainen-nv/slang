//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#simple-modifiers
//META: doc_section_digest=f4322db59ceb8b8af42c196b566ca82e3f4804c47a61babf133a4e241eddf511
//META: purpose=`dyn` is a simple modifier on an `interface` declaration that marks the interface for dynamic dispatch; declaring a `dyn interface` with a conforming struct parses and survives into a clean HLSL / SPIR-V emit.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission fan-out for the `dyn interface` claim onto the remaining
// shader text targets. The sibling `modifier-dyn-interface.slang` pins
// the HLSL and SPIR-V emit; here the same `dyn interface` + conforming
// struct + direct concrete call is lowered to GLSL, Metal, and WGSL. The
// direct call through `AddOne` specializes the dynamic-dispatch interface
// away to a concrete function, so each CHECK pins the resulting concrete
// `AddOne_compute` call and the entry point — the program parses and
// emits cleanly on these back-ends too, which is the recognition signal.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

[anyValueSize(16)]
dyn interface IComputeOp
{
    int compute(int x);
}

struct AddOne : IComputeOp
{
    int compute(int x) { return x + 1; }
}

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    AddOne op;
    outBuf[0] = op.compute(int(41));
}

//GLSL: int AddOne_compute_0(int
//METAL: int AddOne_compute_0(int
//WGSL: fn AddOne_compute_0(
