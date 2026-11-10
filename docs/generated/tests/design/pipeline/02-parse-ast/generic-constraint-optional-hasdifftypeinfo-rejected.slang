//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#generics-ambiguity
//META: purpose=The `optional` prefix is accepted on type, `nonempty`, and `countof` bounds but rejected on a `__hasDiffTypeInfo` clause with E30315.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented carve-out in the `optional` prefix rule. The clause
// is spelled exactly as the accepted forms are, so the rejection can only come
// from the parser recognising which constraint class the clause produced and
// refusing the modifier for that one class. The CHECK pins E30315 on the
// `__hasDiffTypeInfo` token rather than on `optional`, which is where the
// parser reports the clash.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int probe<T>(T x) where optional __hasDiffTypeInfo(T) { return 1; }
//CHECK:                         ^^^^^^^^^^^^^^^^^ error E30315
//CHECK:                         ^^^^^^^^^^^^^^^^^ 'optional' is not supported on '__hasDiffTypeInfo(...)' constraints

void main()
{
    printf("v=%d\n", probe<float>(1.0));
}
