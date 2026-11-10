//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#debug-levels-and--debug-info-include-source
//META: purpose=At -g1 the emitter produces the standard SPIR-V debug instructions OpString and OpLine alongside the bare OpSource.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Minimal (-g1) rung of the debug-level ladder: the IR carries
// debug source and line records, and the emitter turns them into the standard
// (non-NonSemantic) SPIR-V debug instructions. CHECK asserts an OpString file
// record and at least one OpLine appear, and that the source record is still
// the bare language/version form because -debug-info-include-source was not
// requested. The file path in the OpString is machine-dependent, so it is
// matched with a wildcard.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute -g1

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = int(tid.x) + 1;
    outBuf[tid.x] = v;
}

// CHECK-DAG: OpString "{{.*}}debug-info-g1-opline-opstring.slang"
// CHECK-DAG: {{^}}OpSource Slang 1{{$}}
// CHECK-DAG: OpLine %{{[a-zA-Z_0-9]+}}
