//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#downstream-tint
//META: purpose=The wgsl-spirv-asm target compiles the WGSL text through Tint to a SPIR-V module and then disassembles it via glslang into assembly whose OpEntryPoint names main
//META: intent=functional
//META: pipeline_stage=emit
//META: requires-tool=tint
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two-step downstream chain behind the assembly target:
// WGSLSPIRVAssembly first reduces to the WGSLSPIRV intermediate (Tint
// consumes the emitted WGSL and produces a SPIR-V module), then
// glslang disassembles that module to SPIR-V assembly text. The
// CHECKed OpEntryPoint / OpExecutionMode tokens exist only in that
// disassembly, so matching them proves both downstream transitions
// ran.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl-spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 42;
}

// SPIR-V module markers produced by Tint.
// CHECK: OpEntryPoint
// CHECK-SAME: main
// CHECK: OpExecutionMode
