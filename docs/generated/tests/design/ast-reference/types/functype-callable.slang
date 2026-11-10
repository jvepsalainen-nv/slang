//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#functype
//META: purpose=A FuncType holds parameter types followed by a result type; a value of a callable type is invokable to produce its result.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the parameter-then-result shape of a callable type by
// passing a callable value through a generic that only knows it is
// callable with an int and yields an int. CHECK asserts the invoked
// result, which requires both the parameter type and the result type to
// have travelled with the value.

//TEST:INTERPRET(filecheck=CHECK):

interface ICallable { int call(int x); }
struct Doubler : ICallable { int call(int x) { return x * 2; } }

int twice<F : ICallable>(F f, int x) { return f.call(x); }

void main()
{
    Doubler d;
    // CHECK: r=20
    printf("r=%d\n", twice(d, 10));
}
