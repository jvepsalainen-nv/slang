//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debugvar
//META: purpose=A DebugVar for an entry-point parameter carries the optional argument-index operand after source, line, column and scope.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the present case of the optional fifth operand. The entry point's
// only parameter is argument 0, so its variable record must take the
// five-operand form; the CHECK pins the closing parenthesis after the index so
// a four-operand record would not match, and the captured source id is
// required to be the module's `DebugSource` rather than a name string -- the
// point of the notable-opcode callout about the stale generated accessors.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: %[[SRC:[0-9]+]]{{.*}}= DebugSource(
// CHECK: = DebugVar(%[[SRC]], {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, %{{[A-Za-z0-9_]+}}, 0 : UInt)
