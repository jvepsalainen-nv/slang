//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#performmandatoryearlyinlining-and-the-surrounding-loop
//META: purpose=A call to a same-module force-inline-early function is a hard requirement rather than a hint, so it is gone from the pre-link snapshot while an ordinary call survives.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the Phase C inlining loop treats the force-inline-early
// attribute as an obligation. The sibling test in this bundle exercises the
// cross-module path where prelink first has to import the body; this one
// removes that variable by declaring both callees in the same file, so the
// only difference between them is the attribute. Both are called from the
// entry point with a `uniform` argument, which keeps the calls from being
// folded for any other reason. The CHECKs assert the annotated callee's
// body has been substituted at the call site as a multiply, while the
// ordinary callee is still reached through a `call`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

RWStructuredBuffer<int> outBuf;
uniform int a;

[__unsafeForceInlineEarly]
int forced(int x)
{
    return x * 3;
}

int normal(int x)
{
    return x + 7;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    outBuf[0] = forced(a) + normal(a);
}

// The forced callee's body appears inline in main; only the ordinary
// callee is still reached through a call instruction.
// CHECK: func %main
// CHECK-DAG: mul(%a, 3 : Int)
// CHECK-DAG: call %normal(%a)
// CHECK-NOT: call %forced
