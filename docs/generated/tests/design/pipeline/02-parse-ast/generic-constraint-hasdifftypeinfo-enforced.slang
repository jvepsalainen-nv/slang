//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#generics-ambiguity
//META: purpose=The `where __hasDiffTypeInfo(T)` spelling parses into its own constraint decl, which the checker enforces at specialization (E30440 when unsatisfied).
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `__hasDiffTypeInfo(T)` where-clause spelling produces
// a real, enforced constraint: specializing with a plain struct that
// carries no differentiable-type info fails with the
// constraint-not-satisfied diagnostic naming the constraint. That the
// error renders `__hasDiffTypeInfo(T)` proves the spelling parsed into
// a dedicated constraint decl rather than being dropped.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Plain
{
    int v;
}

T passDiff<T>(T x) where __hasDiffTypeInfo(T)
{
    return x;
}

void main()
{
    Plain p;
    passDiff(p);
//CHECK: E30440
//CHECK: could not satisfy the generic constraint '__hasDiffTypeInfo(T)'
}
