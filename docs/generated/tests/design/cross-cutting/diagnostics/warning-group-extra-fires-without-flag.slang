//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#warning-groups
//META: purpose=A warning tagged with the `extra` sentinel fires with no `-W` flag, because the enabled-group mask starts with the `Extra` bit set.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out the doc calls out for authors: `extra` is not an opt-in
// group in practice because its bit is pre-set. 20103 (keyword used as a name)
// carries the extra sentinel; the caret-anchored CHECK asserts it is reported at
// the offending declarator with no warning flag on the command line.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int main()
{
    int enum = 1;
//CHECK:^^^^ E20103
//CHECK:^^^^ 'enum' is a type keyword
    return enum;
}
