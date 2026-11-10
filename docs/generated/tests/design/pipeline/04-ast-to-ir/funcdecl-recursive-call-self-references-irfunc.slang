//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A FuncDecl that calls itself lowers to a single IRFunc whose body contains a `call %self(...)` instruction targeting the same IRFunc — the doc's `InvokeExpr -> IRCall` row applied to a self-reference.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: function call-shape axis — recursion. The "InvokeExpr ->
// IRCall" row says nothing about whether the callee is the enclosing
// function. A recursive callee is observable as the same `%factorial`
// name appearing both on `func %factorial` and inside `call
// %factorial(...)`.

// Later passes reject recursion on every target (E55201), so the test
// expects exit code -1; the lowering IR dump is still emitted first.

//TEST:SIMPLE(filecheck=CHECK, exit-code=-1):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int factorial(int n)
{
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = factorial(a);
}

// CHECK-LABEL: func %factorial
// CHECK: call %factorial(%{{.*}})
// CHECK: E55201
