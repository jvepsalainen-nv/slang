//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#throwstmt-and-catchstmt
//META: purpose=Nested CatchStmt blocks resolve to the innermost matching handler; a throw inside an inner try is caught by the inner handler and the outer handler does not fire.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies nested protected bodies resolve a thrown error to the
// innermost enclosing handler. The inner handler writes 11 and the
// outer writes 22; the CHECK asserts 11, so the outer handler never
// saw the error.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT:ubuffer(data=[0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

enum Err { Fail }

int risky() throws Err
{
    throw Err.Fail;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    int r = 0;
    do
    {
        do
        {
            r = try risky();
        }
        catch (inner: Err)
        {
            r = 11;
        }
    }
    catch (outer: Err)
    {
        r = 22;
    }
    outputBuffer[0] = r;
}
//CHECK: 11
