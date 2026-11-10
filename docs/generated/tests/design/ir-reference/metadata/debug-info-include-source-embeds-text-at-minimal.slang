//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=The -debug-info-include-source flag embeds the source text into DebugSource even at Minimal, the one exception to the debug-level rule.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out that the level ladder otherwise implies is
// impossible: at Minimal the text operand is empty, but the flag overrides
// that without raising the level. The test compiles at `-g1` with the flag and
// requires the record to hold the shader's own declaration text, while the
// same run must still not have gained the variable records that only Standard brings --
// which is what shows the flag moved the text operand and not the level.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g1 -debug-info-include-source

uniform RWStructuredBuffer<int> markerBuffer;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    markerBuffer[0] = int(tid.x);
}

// The embedded text is the whole file on one line, with newlines escaped, so
// the buffer declaration above appears inside the string operand.
// CHECK: = DebugSource("{{.*}}", "{{.*}}uniform RWStructuredBuffer<int> markerBuffer;{{.*}}", false)
// The level is still Minimal, so the variable-level records were not built.
// The opcode name is split by a one-character regex so that this very line,
// echoed back inside the source operand above, cannot satisfy its own
// CHECK-NOT.
// CHECK-NOT: = DebugVa{{r}}(
