//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=A `using` declaration only extends the sibling chain of the scope captured where it was written, so a `using` inside a namespace does not make the names unqualified outside that namespace.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the destination of a `using` is the scope in force at the
// point the declaration is written. `using Util;` sits inside namespace App,
// so App's scope gains Util as a sibling. Inside App, `triple` binds without
// qualification — `App::run(4)` is called from `main` and must type-check,
// which it only does if that binding worked. At file scope the same bare
// `triple` must fail, and the annotated E30015 pins that boundary.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

namespace Util
{
    int triple(int x) { return 3 * x; }
}

namespace App
{
    using Util;
    int run(int v) { return triple(v); }
}

void main()
{
    int inside = App::run(4);
    int outside = triple(4);
//CHECK:          ^^^^^^ undefined identifier
//CHECK:          ^^^^^^ undefined identifier 'triple'.
// CHECK: E30015
    printf("%d\n", inside + outside);
}
