//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#diagnostics-during-lowering
//META: purpose=A chain of 128 nested ordinary calls is the last depth that stays under the invoke-lowering recursion guard: lowering completes and no E39997 is reported (129 is the first to fail).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary partner of invoke-lowering-recursion-depth-exceeded.slang. The
// guard runs before the counter increments, so 128 nested InvokeExprs still
// compile. The CHECK-NOT pins that E39997 is absent and the positive CHECK
// that lowering finished.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<int> outputBuffer;

int f(int v) { return v + 1; }

[numthreads(1, 1, 1)]
void main()
{
    int x = 0;
    outputBuffer[0] = f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(x))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
}

// CHECK-NOT: E39997
// CHECK: func %main
