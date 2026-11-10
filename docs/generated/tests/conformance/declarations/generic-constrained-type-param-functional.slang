//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#generics
//META: purpose=A generic type parameter constrained with `: IFoo` allows the function to call interface members on that parameter.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `T : IHasScore` constraint allows the generic body to call interface methods.
// `sumScores<T>` calls `getScore()` on both arguments; 50 confirms the method
// dispatch worked, which is only possible if the constraint was satisfied.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasScore { int getScore(); }

int sumScores<T : IHasScore>(T a, T b) { return a.getScore() + b.getScore(); }

struct Player : IHasScore
{
    int score;
    int getScore() { return score; }
}

void main()
{
    Player p1, p2;
    p1.score = 30;
    p2.score = 20;
    // CHECK: 50
    printf("%d\n", sumScores(p1, p2));
}
