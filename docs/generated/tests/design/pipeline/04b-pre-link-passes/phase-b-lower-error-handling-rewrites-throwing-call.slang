//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#lowererrorhandling
//META: purpose=Phase B's lowerErrorHandling (B2) rewrites a throwing function to return Result<T,E> and turns the try-call into an ordinary call plus an ifElse on the result tag, leaving no tryCall behind.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both halves of the error-handling rewrite in one module. The
// callee `doIt` is declared `throws`, so after B2 its IR signature must
// return a `Result(...)` and its two exits must build that result with
// `makeResultError` / `makeResultValue`. At the caller, the `try` becomes
// a plain `call` whose result is tested with `isResultError` and branched
// on with `ifElse`; the closing CHECK-NOT asserts no `tryCall` opcode is
// left anywhere for a downstream pass to have to understand.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

enum MyError { Fail }

uniform int a;
uniform RWStructuredBuffer<int> buf;

int doIt(int x) throws MyError
{
    if (x < 0) throw MyError.Fail;
    return x + 1;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    do { buf[0] = try doIt(a); } catch (MyError e) { buf[0] = -1; }
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK: func %doIt : Func(Result(
// CHECK-DAG: makeResultError(
// CHECK-DAG: makeResultValue(
// CHECK-LABEL: func %main
// CHECK: call %doIt(
// CHECK: isResultError(
// CHECK: ifElse(
// CHECK-NOT: tryCall(
