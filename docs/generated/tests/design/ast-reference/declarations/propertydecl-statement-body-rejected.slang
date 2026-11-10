//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#accessordecl-family
//META: purpose=A property body is a braced list of accessor declarations, so a body made of statements is a parse error rather than an implicit getter; only the empty body and the semicolon form leave the declaration with no accessor for checking to fill in.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary of the implicit-getter rule. Because an empty property
// body is later treated like `{ get; }`, it is tempting to read a body with
// statements as the same shorthand with the body supplied. It is not: every
// member of the braced list must begin with `get`, `set` or `ref`, so the
// `return` is rejected while it is still being parsed. CHECK pins E20003 at
// the `return` keyword; the sibling test
// accessordecl-implicit-getter-property.slang shows the accepted empty form.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S
{
    int v;
    property int p { return v; }
//CHECK:             ^^^^^^ E20003
}

void main()
{
    S s;
    s.v = 3;
    printf("%d\n", s.p);
}
