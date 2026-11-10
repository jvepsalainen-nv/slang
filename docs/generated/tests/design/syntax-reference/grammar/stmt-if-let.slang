//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`IfLetStmt` parses as `'if' '(' 'let' IDENT '=' Expr ')' Stmt ('else' Stmt)?`, selected over `IfStmt` when `let` follows the `(`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `let` two tokens after `if` selects the binding form
// rather than an ordinary condition, and that the binding is in scope
// in the then-branch. Both arms are exercised from locals: the bound
// arm reads the payload through the new name (42 could not be produced
// without the binding), and the else arm proves the empty case takes
// the alternative statement.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    Optional<int> some = 41;
    Optional<int> nothing = none;

    int bound = 0;
    if (let v = some) { bound = v + 1; }
    else { bound = -1; }

    int empty = 0;
    if (let v = nothing) { empty = v + 1; }
    else { empty = -1; }

    // CHECK: bound=42 empty=-1
    printf("bound=%d empty=%d\n", bound, empty);
}
