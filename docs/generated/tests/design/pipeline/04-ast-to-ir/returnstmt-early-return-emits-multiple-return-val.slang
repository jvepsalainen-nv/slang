//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=Multiple ReturnStmts in a single FuncDecl each lower to their own `return_val(...)` terminator inside distinct basic blocks, all of which terminate the same IRFunc.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: return-shape axis — early return / multiple returns.
// The doc's row "ReturnStmt -> IRReturn terminator" applies once per
// source-level `return`. With three return statements the IRFunc
// body contains three distinct `return_val(...)` terminators in
// separate blocks.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int clamp01(int v)
{
    if (v < 0) return -1;
    if (v > 100) return 100;
    return v;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = clamp01(a);
}

// CHECK-LABEL: func %clamp01
// CHECK: return_val(-1 : Int)
// CHECK: return_val(100 : Int)
// CHECK: return_val(%{{.*}})
