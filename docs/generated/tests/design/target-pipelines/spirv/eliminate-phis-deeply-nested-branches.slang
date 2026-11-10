//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#eliminatephis-with-spir-v-specific-options
//META: purpose=Deeply nested if/else branches (6 distinct assigned values) all funnel into a single Function-storage OpVariable via OpStore; no OpPhi survives because eliminatePhis runs with useRegisterAllocation=true.
//META: intent=stress
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: many phi candidates from nested if/else chains.
// eliminatePhis must collapse all six branches into a single
// register-allocated local; the emit should contain at least
// 6 OpStore instructions targeting the local and no OpPhi.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = int(tid.x);
    int r;
    if (v > 0) {
        if (v > 10) {
            if (v > 100) r = 3;
            else         r = 2;
        } else {
            r = 1;
        }
    } else {
        if (v < -10) {
            if (v < -100) r = -3;
            else          r = -2;
        } else {
            r = -1;
        }
    }
    outBuf[tid.x] = r;
}

// CHECK: %r = OpVariable %_ptr_Function_int Function
// CHECK-NOT: OpPhi
// CHECK-DAG: OpStore %r %int_3
// CHECK-DAG: OpStore %r %int_2
// CHECK-DAG: OpStore %r %int_1
// CHECK-DAG: OpStore %r %int_n1
// CHECK-DAG: OpStore %r %int_n2
// CHECK-DAG: OpStore %r %int_n3
