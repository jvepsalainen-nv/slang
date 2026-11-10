//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=Omitting the terminating semicolon of a ThrowStmt is a parse error.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The negative half of `ThrowStmt ::= 'throw' Expr ';'`. Its sibling
// stmt-throw-requires-semicolon.slang shows the well-formed form runs; this one
// pins the boundary itself, so that making the semicolon optional again would be
// caught rather than silently accepted. The caret lands on the `}` that follows
// the semicolon-less `throw`, which is where ParseThrowStatement's
// ReadToken(TokenType::Semicolon) reports.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl

enum TErr
{
    Boom
}

func trip(x : int) throws TErr -> int
{
    if (x > 0)
    {
        throw TErr.Boom
    }
/*CHECK:
    ^ E20001
    ^ unexpected '}', expected ';'
*/
    return 0;
}
