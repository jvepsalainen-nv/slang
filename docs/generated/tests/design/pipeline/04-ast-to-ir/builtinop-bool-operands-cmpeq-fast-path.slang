//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#builtin-operators-bypass-call-lowering
//META: purpose=A builtin `==` on `bool` operands is fast-pathed like numeric operands and lowers to a single pure `cmpEQ` inst — no call instruction precedes it in the body.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: operand-type axis (bool). The fast path is documented for
// builtin numeric *or bool* operands; `==` on two bools must lower to
// one `cmpEQ` reached without any `call` (callable resolution is
// skipped). The compared result feeds an `if` so the value escapes
// through an int buffer without any bool storage or cast.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool a;
uniform bool b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int r = 0;
    if (a == b)
        r = 1;
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK-NOT: = call
// CHECK: cmpEQ(%{{.*}}, %{{.*}})
