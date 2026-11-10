//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=DebugFunction carries the optional trailing parentScope operand at full debug level, referencing the DebugCompilationUnit.
//META: intent=boundary
//META: pipeline_stage=lower-to-ir
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The present-form half of the `DebugFunction` boundary pair. The doc gives the
// operand list as `name, line, col, file, debugType, parentScope?` — the last
// one optional — and this bundle's rule is that an optional operand needs both
// a present-form and an absent-form test, since only the pair distinguishes an
// optional operand from a fixed one.
//
// `debug-function-name-line-col-file-type.slang` pins only the five fixed
// operands at `-g1`, and `debug-function-parent-scope-present-at-minimal.slang`
// shows the sixth operand is present at `-g1` too. This test pins the
// trailing reference at full `-g`. The absent form needs an `#include`d file.
//
// At full `-g` the `DebugSource` record embeds the entire text of this file, so
// the dump contains a copy of these CHECK lines and a naive pattern can match
// itself. The pattern below is anchored on the `let %N : Void =` instruction
// prefix that only a real dumped instruction carries, which no echoed comment
// line reproduces.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// The record ends with a sixth operand referencing the compilation-unit scope,
// where the `-g1` form ends after the function type.
// CHECK: let {{.*}}: Void{{.*}}= DebugFunction("main", {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, %{{[0-9]+}}, Func({{.*}}), %{{[0-9]+}})
