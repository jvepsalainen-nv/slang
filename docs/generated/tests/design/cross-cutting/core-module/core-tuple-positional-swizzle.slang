//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#what-the-core-module-provides
//META: purpose=A core-module Tuple's positional members compose into a swizzle, so t._2_1_0 yields a reordered Tuple with no import.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `Tuple`'s positional members are not merely named fields
// but a swizzle vocabulary: a three-element tuple built with makeTuple is
// re-read through the compound member `_2_1_0`, which must itself be a
// Tuple whose own `_0` / `_1` / `_2` come back in reverse order. Reading
// the result through its positional members is what proves the swizzle
// produced a tuple rather than a single element, and the whole thing is
// written with no `import`, so the vocabulary can only have come from the
// core module.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    Tuple<int, int, int> t = makeTuple(10, 20, 30);
    let reversed = t._2_1_0;
    // CHECK: forward=10,20,30 reversed=30,20,10
    printf("forward=%d,%d,%d reversed=%d,%d,%d\n",
           t._0, t._1, t._2,
           reversed._0, reversed._1, reversed._2);
}
