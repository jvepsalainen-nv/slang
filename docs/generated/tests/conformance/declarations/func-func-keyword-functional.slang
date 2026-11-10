//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#functions
//META: purpose=The `func` keyword declares a function with `name: type` parameter syntax and `-> result-type` result clause.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `func` keyword syntax: `name: type` parameter pairs and `->` result type.
// `add(x: int, y: float) -> float` is called with concrete arguments and the result 5
// printed; CHECK confirms the function compiled and executed correctly.

//TEST:INTERPRET(filecheck=CHECK):

func add(x: int, y: float) -> float { return float(x) + y; }

void main()
{
    // CHECK: 5
    printf("%g\n", add(3, 2.0));
}
