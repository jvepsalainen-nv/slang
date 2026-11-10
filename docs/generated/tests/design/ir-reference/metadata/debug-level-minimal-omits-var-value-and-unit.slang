//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=Debug level Minimal (-g1) produces no DebugVar or DebugValue, both of which the Standard level adds; the DebugCompilationUnit is built at every level above None.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Minimal/Standard split, which is the fact a reader needs before
// concluding a record is missing from the compiler rather than from the chosen
// level. The `MIN` run anchors on the dump banner and then forbids the two
// variable-level records through to end of input; the `STD` run compiles the
// identical shader one level up and finds them along with the compilation
// unit, which Minimal also builds so that a module serialized at `-g1` can be
// compiled at `-g2` later. Every `STD` pattern
// carries a `{{...}}` regex on purpose: at Standard the source record embeds a
// verbatim copy of this file, so a pattern spelled as plain text would match
// its own CHECK line in the echoed source instead of a real record.

//TEST:SIMPLE(filecheck=MIN):-target spirv-asm -dump-ir -o - -entry main -stage compute -g1
//TEST:SIMPLE(filecheck=STD):-target spirv-asm -dump-ir -o - -entry main -stage compute -g2

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int scaled = int(tid.x) * 3;
    buf[0] = scaled;
}

// MIN: {{^}}### LOWER-TO-IR:
// MIN-NOT: = DebugVar(
// MIN-NOT: DebugValue(

// STD-DAG: = DebugCompilationUnit(%{{[0-9]+}})
// STD-DAG: = DebugVar(%{{[0-9]+}}, {{[0-9]+}} : UInt
// STD-DAG: DebugValue(%{{[A-Za-z0-9_]+}}, %{{[A-Za-z0-9_]+}})
