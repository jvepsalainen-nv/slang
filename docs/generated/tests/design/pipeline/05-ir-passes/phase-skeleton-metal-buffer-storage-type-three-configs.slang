//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#phase-skeleton-of-linkandoptimizeir
//META: purpose=`lowerBufferElementTypeToStorageType` runs in three configurations for Metal, so a Metal compile produces three of its dump stages.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the phase-skeleton's explicit "(three configurations for
// Metal)" parenthetical. Compiling a buffer-using compute kernel to
// Metal while dumping only that pass and requiring three consecutive
// `### AFTER lowerBufferElementTypeToStorageType:` labels shows the
// orchestrator invoked the pass three separate times; a Metal pipeline
// with fewer configurations would leave a CHECK-LABEL unmatched.

//TEST:SIMPLE(filecheck=CHECK):-target metal -dump-ir-after lowerBufferElementTypeToStorageType -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x) + 1;
}

// CHECK-LABEL: ### AFTER lowerBufferElementTypeToStorageType:
// CHECK-LABEL: ### AFTER lowerBufferElementTypeToStorageType:
// CHECK-LABEL: ### AFTER lowerBufferElementTypeToStorageType:
