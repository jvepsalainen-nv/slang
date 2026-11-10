//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#generics-ambiguity
//META: purpose=The `where nonempty(Pack)` spelling parses into a pack constraint and a call supplying a non-empty pack satisfies it.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `nonempty(Pack)` where-clause spelling. A variadic
// generic constrained with `where nonempty(T)` is specialized with a
// two-element pack; the printed sum proves the constraint parsed,
// was satisfied, and the specialization ran.

//TEST:INTERPRET(filecheck=CHECK):

int sumAll<each T>(expand each T args) where nonempty(T) where T == int
{
    int total = 0;
    expand(total = total + (each args));
    return total;
}

void main()
{
    // CHECK: sum=30
    printf("sum=%d\n", sumAll(10, 20));
}
