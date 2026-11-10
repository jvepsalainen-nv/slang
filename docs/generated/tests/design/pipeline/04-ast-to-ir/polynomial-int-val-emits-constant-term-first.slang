//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#builtin-operators-bypass-call-lowering
//META: purpose=An array extent `N + 1` on a generic value parameter never forms a `BuiltinOperationIntVal`; it arrives as a `PolynomialIntVal` that lowers to `constexprAdd(1 : Int, %N)` with the constant term emitted first, so the operand order does not follow the source.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out that `+`, `-`, `*` and unary `-` take a different
// `Val` route from `/`: they are folded into a `PolynomialIntVal` during
// checking, and `visitPolynomialIntVal` emits the polynomial's constant term
// before its variable term. The observable consequence is operand order — the
// source says `N + 1` but the lowered inst reads `constexprAdd(1 : Int, %N)`.
// Pinning the literal in the *first* operand slot is what distinguishes the
// polynomial path from the `BuiltinOperationIntVal` path, which would have
// preserved source order the way `constexprDiv(%N, 2 : Int)` does.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<int> outputBuffer;

int g<let N : int>()
{
    int b[N + 1];
    b[0] = 2;
    return b[0];
}

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = g<8>();
}

// Constant term first: the literal precedes the generic parameter.
// CHECK: constexprAdd(1 : Int, %N{{[0-9]*}})
