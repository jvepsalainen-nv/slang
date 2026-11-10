//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=SPIR-V emit begins with the canonical ; SPIR-V text prelude and a ; Version: 1.X line.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The SPIR-V text disassembly prelude is a fixed canonical
// header: a "; SPIR-V" comment, a version number, the generator
// metadata, and a bound. emitPhysicalLayout writes it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) + 100;
}

// CHECK: ; SPIR-V
// CHECK: ; Version:
// CHECK: ; Generator:
// CHECK: ; Bound:
