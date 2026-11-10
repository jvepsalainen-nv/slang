//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#loop
//META: purpose=The back-edge of a loop is an unconditionalBranch back to the loop header carrying the updated induction values as argument operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// At the end of each loop iteration, the continue block branches
// back to the body header carrying the next iteration's induction
// values — both the running sum and the incremented index.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        s = s + i;
    }
    buf[0] = s;
}

// CHECK-LABEL: func %main
// CHECK: add(%i, 1 : Int)
// CHECK: unconditionalBranch(%{{[0-9]+}}, %{{[a-zA-Z0-9_]+}}, %{{[a-zA-Z0-9_]+}})
