//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=An OutParamType parameter starts unassigned, so reading it before the callee writes it is diagnosed as use of an uninitialized value.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe of the out passing mode: unlike inout, an out
// parameter carries no incoming value, so a read before the first write
// has nothing to read. CHECK pins the uninitialized-out-parameter
// diagnostic on the reading line, which would not fire if `out` were
// treated as `inout`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void readsOut(out int x)
{
    int y = x + 1;
//CHECK:      ^ use of uninitialized out parameter 'x'
    x = y;
}

void main() { int z; readsOut(z); }
