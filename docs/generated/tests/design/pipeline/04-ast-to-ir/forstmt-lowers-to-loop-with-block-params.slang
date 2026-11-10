//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A ForStmt lowers to a `loop` terminator; the induction variable is carried as a block `param` (phi-style joining encoded as block parameters).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc claims `ForStmt` → structured branch and that "phi-style
// joining is encoded as block parameters (IRParam at the start of a
// block) rather than explicit phi instructions". The for-loop
// induction variable shows up as a block `param`, and the loop
// header is reached by `loop(...)`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int sum = 0;
    for (int i = 0; i < n; i++)
        sum += i;
    buf[0] = sum;
}

// CHECK-LABEL: func %main
// CHECK: loop(%{{.*}}
// CHECK: param %i
// CHECK: param %sum
