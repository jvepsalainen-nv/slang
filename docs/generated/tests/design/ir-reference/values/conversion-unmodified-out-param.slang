//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=The core-module `unmodified(x)` marker lowers to the no-op `unmodified` cast opcode applied to the `out` parameter it annotates.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `unmodified` survives lowering as its own instruction
// rather than being erased at the AST level, and that its operand is the
// `out` parameter itself. The helper takes `out int o`, marks it, then
// writes it; CHECK asserts the callee's parameter is typed
// `OutParam(Int)` and that `unmodified(%o)` appears before the `store`,
// which shows the marker is attached to the parameter's pointer and not
// to a copy.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

void helper(out int o)
{
    unmodified(o);
    o = a;
}

[numthreads(1, 1, 1)]
void main()
{
    int x;
    helper(x);
    buf[0] = x;
}

// IR-LABEL: func %helper	: Func(Void, OutParam(Int))
// IR: param %o	: OutParam(Int)
// IR: unmodified(%o)
// IR: store(%o, %a)
