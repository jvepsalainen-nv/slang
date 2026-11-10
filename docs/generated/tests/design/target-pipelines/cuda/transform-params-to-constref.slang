//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#undoparametercopy-and-transformparamstoconstref
//META: purpose=transformParamsToConstRef converts struct value parameters into pointer-form parameters on CUDA for pass-by-reference.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDA shares this arm with CPU / Metal at line ~2050. Struct value
// parameters are rewritten to pointer-form so the callee accesses
// fields through `ptr->field` rather than copying the whole struct
// onto the call stack.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

struct Big { int a; int b; int c; int d; int e; };

int sumIt(Big v) { return v.a + v.b + v.c + v.d + v.e; }

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Big b = { int(tid.x), int(tid.y), 3, 4, 5 };
    outBuf[tid.x] = sumIt(b);
}

// CHECK: sumIt{{[_0-9]*}}(Big_{{[0-9]+}} *
