//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#type-expression-family-pointertypeexpr-functypeexpr-tupletypeexpr-andtypeexpr-modifiedtypeexpr-packbranchtypeexpr
//META: purpose=A function-type expression requires the functype keyword as part of its spelling, and a parameter declared functype(T, T) -> T accepts an ordinary function and calls it.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the spelling of the function-type expression. `(int, int) -> int`
// on its own is not a type; the keyword is what makes the parser build the
// node, which is why the core module's callback parameters are written
// `functype(T, T) -> T`. The test declares a parameter with exactly that shape
// and passes two different ordinary functions to it, so the CHECK's two
// results can only both appear if the parameter really is a callable type and
// not, say, an unresolved name that happened to parse.

//TEST:INTERPRET(filecheck=CHECK):

int applyOp(functype(int, int) -> int op, int a, int b)
{
    return op(a, b);
}

int add(int a, int b)
{
    return a + b;
}

int scaleAdd(int a, int b)
{
    return a * b + 1;
}

void main()
{
    printf("add=%d scaleAdd=%d\n", applyOp(add, 3, 4), applyOp(scaleAdd, 3, 4));
}

//CHECK: add=7 scaleAdd=13
