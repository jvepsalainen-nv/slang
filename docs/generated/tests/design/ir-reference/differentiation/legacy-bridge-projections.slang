//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#legacy-bridge
//META: purpose=The three legacy-bridge projection opcodes each take the same (targetFunc, legacyBwdDiffFunc) operand pair and differ only in which phase they project.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the shared-operand-pair claim about the legacy bridge. A
// `[BackwardDerivative(myBwd)]` attribute is the user surface that puts a
// historical combined reverse function on `h`, and checking then synthesizes
// the modern three phases as projections out of it. CHECK first binds the
// combined function value, then the three CHECK-DAG patterns require every
// projection to carry exactly the two operands `(%h, <combined>)` — the same
// pair for all three — so the phase is carried by the opcode identity alone.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform RWStructuredBuffer<float> buf;

void myBwd(inout DifferentialPair<float> dpx, float dOut)
{
    dpx = DifferentialPair<float>(dpx.p, 2.0 * dpx.p * dOut);
}

[BackwardDerivative(myBwd)]
float h(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    DifferentialPair<float> dp = DifferentialPair<float>(a, 0.0);
    __bwd_diff(h)(dp, 1.0);
    buf[0] = dp.d;
}

// CHECK: let [[BWD:%[A-Za-z0-9_]+]] :{{.*}}= FunctionCopy(%myBwd)
// CHECK-DAG: = BackwardPropagateFromLegacyBwdDiffFunc(%h, [[BWD]])
// CHECK-DAG: = BackwardPrimalFromLegacyBwdDiffFunc(%h, [[BWD]])
// CHECK-DAG: = BackwardRematFromLegacyBwdDiffFunc(%h, [[BWD]])
