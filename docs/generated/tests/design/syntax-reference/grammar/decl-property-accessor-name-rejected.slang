//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#function-style-declarations
//META: purpose=`AccessorName` is limited to `'get' | 'set' | 'ref'`; any other accessor name is diagnosed.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an accessor block rejects a name outside the
// documented get/set/ref set. `modify` is used as the probe (it is
// not in the current AccessorName production), and the parser must
// emit its unexpected-token diagnostic E20003 on it.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S
{
    int v;

    property val : int
    {
        modify { return v; }
//CHECK:^^^^^^ error E20003
//CHECK:^^^^^^ unexpected identifier
    }
}

void main()
{
}
