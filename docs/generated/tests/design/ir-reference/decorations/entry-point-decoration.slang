//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entrypoint--entrypointdecoration
//META: purpose=A function marked with shader/numthreads attributes lowers to a func with an entryPoint decoration carrying profile-int, entry-name, and module-name operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the three-operand shape of `entryPoint`: an integer profile tag,
// the user-visible entry name as a string, and the module name. The CHECK
// pins the operand *kinds* (`{{[0-9]+}} : Int`, then `"main"`) and
// wildcards the module name, which is derived from the source file name and
// would otherwise make the test filename-dependent.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(8, 4, 2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [entryPoint({{[0-9]+}} : Int, "main", "{{.*}}")]
// CHECK: func %main
