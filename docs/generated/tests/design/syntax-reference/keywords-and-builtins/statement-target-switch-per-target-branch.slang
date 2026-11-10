//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#statement-keywords
//META: purpose=`__target_switch` is a statement keyword dispatched at statement entry (`parseTargetSwitchStmt`); each `case <target>` arm reuses the documented `case`/`default` keywords and only the arm matching the active target survives into the emitted code.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the parser recognizes `__target_switch` at statement head
// and reuses `case` / `default` labels inside its body. A helper
// returns a distinct constant per target arm; the HLSL emit must
// contain the hlsl-arm constant and never the glsl-arm constant, and
// vice versa — only target-selected code reaches emission, which is
// only possible if the statement parsed as a target switch rather
// than an ordinary switch.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute

int pickPerTarget()
{
    __target_switch
    {
    case hlsl:
        return 111333;
    case glsl:
        return 222333;
    default:
        return 999333;
    }
}

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    // HLSL-NOT: 222333
    // HLSL: 111333
    // HLSL-NOT: 222333
    // GLSL-NOT: 111333
    // GLSL: 222333
    // GLSL-NOT: 111333
    outBuf[0] = pickPerTarget();
}
