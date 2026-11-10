//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#edge-cases-and-failure-modes
//META: purpose=Under a no-applicable-overload error each candidate note is followed by an argument-N-does-not-match note built from the recorded mismatch index and both types.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-candidate mismatch reporting. The first argument matches
// both candidates and the second does not, so the recorded mismatch index must
// be 1 rather than 0. CHECK pins the primary error and the note that names the
// index and both types.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Custom { int v; }

int handle(int x, int y)     { return 1; }
/*CHECK:
    ^^^^^^ argument 1 does not match: expected 'int', got 'Custom'
*/
int handle(float x, float y) { return 2; }

void main()
{
    Custom c;
    int t = handle(1, c);
//CHECK:          ^ no overload for 'handle' applicable to arguments of type (int, Custom)
    printf("%d\n", t);
}
