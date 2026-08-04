// THROWAWAY SPIKE — do not polish, do not land.
//
// Phase 2 question: does moving internals tests into a standalone static-linked
// executable force us to ABANDON the existing `SLANG_UNIT_TEST` authoring style?
//
// This file is written entirely in the *existing* style — SLANG_UNIT_TEST,
// SLANG_CHECK, SLANG_CHECK_ABORT, UnitTestContext — with no changes to
// tools/unit-test/. The only new thing is the ~40-line driver `main()` at the
// bottom, which replaces slang-test's dlopen+reporter host.
//
// Exit code 0 = the existing style works unchanged in an exe.

#include "../../include/slang-com-ptr.h"
#include "../../include/slang.h"
#include "../../source/slang/slang-ast-builder.h"
#include "../../source/slang/slang-ir-dce.h"
#include "../../source/slang/slang-ir-insts.h"
#include "../../source/slang/slang-ir.h"
#include "../../source/slang/slang-mangle.h"
#include "../../source/slang/slang-session.h"
#include "unit-test/slang-unit-test.h"

#include <cstdio>

using namespace Slang;

// Helper shared by the tests: reach the internal Session* behind the public
// ISession, the way the April design doc's fixture did.
static Linkage* _createTestLinkage(
    UnitTestContext* unitTestContext,
    ComPtr<slang::ISession>& outSession)
{
    slang::TargetDesc targetDesc = {};
    targetDesc.format = SLANG_SPIRV;
    targetDesc.profile = unitTestContext->slangGlobalSession->findProfile("spirv_1_5");
    slang::SessionDesc sessionDesc = {};
    sessionDesc.targetCount = 1;
    sessionDesc.targets = &targetDesc;
    unitTestContext->slangGlobalSession->createSession(sessionDesc, outSession.writeRef());
    return static_cast<Linkage*>(outSession.get());
}

static int countInsts(IRModule* module, IROp op)
{
    int count = 0;
    for (auto child : module->getGlobalInsts())
    {
        if (child->getOp() == op)
            count++;
    }
    return count;
}

// --- IR pass test, hand-built module (Approach B from the April design doc).
SLANG_UNIT_TEST(internalsIRDeadCodeElimination)
{
    ComPtr<slang::ISession> sessionCom;
    auto linkage = _createTestLinkage(unitTestContext, sessionCom);
    SLANG_CHECK_ABORT(linkage != nullptr);

    RefPtr<IRModule> module = IRModule::create(linkage->getSessionImpl());
    SLANG_CHECK_ABORT(module != nullptr);

    IRBuilder builder(module.get());
    auto addVoidFunc = [&](bool keepAlive)
    {
        builder.setInsertInto(module.get());
        IRFunc* func = builder.createFunc();
        func->setFullType(builder.getFuncType(0, nullptr, builder.getVoidType()));
        builder.setInsertInto(func);
        builder.emitBlock();
        if (keepAlive)
            builder.addKeepAliveDecoration(func);
        builder.emitReturn();
    };
    addVoidFunc(/*keepAlive*/ true);
    addVoidFunc(/*keepAlive*/ false);

    SLANG_CHECK(countInsts(module.get(), kIROp_Func) == 2);
    SLANG_CHECK(eliminateDeadCode(module.get()));
    SLANG_CHECK(countInsts(module.get(), kIROp_Func) == 1);
}

// --- AST test: type construction and the dedup invariant.
SLANG_UNIT_TEST(internalsASTTypeDeduplication)
{
    ComPtr<slang::ISession> sessionCom;
    auto linkage = _createTestLinkage(unitTestContext, sessionCom);
    SLANG_CHECK_ABORT(linkage != nullptr);

    ASTBuilder* astBuilder = linkage->getASTBuilder();
    SLANG_CHECK_ABORT(astBuilder != nullptr);

    Type* floatType = astBuilder->getFloatType();
    Type* intType = astBuilder->getIntType();
    auto* three = astBuilder->getIntVal(intType, 3);
    Type* float3a = astBuilder->getVectorType(floatType, three);
    Type* float3b = astBuilder->getVectorType(floatType, three);
    Type* float4 = astBuilder->getVectorType(floatType, astBuilder->getIntVal(intType, 4));

    SLANG_CHECK(float3a == float3b);
    SLANG_CHECK(float3a->equals(float3b));
    SLANG_CHECK(!float3a->equals(float4));
    SLANG_CHECK(getMangledTypeName(astBuilder, float3a) != getMangledTypeName(astBuilder, float4));
}

// --- Semantic-checker test: assert on the internal checked AST.
SLANG_UNIT_TEST(internalsCheckedASTIsWalkable)
{
    ComPtr<slang::ISession> sessionCom;
    auto linkage = _createTestLinkage(unitTestContext, sessionCom);
    SLANG_CHECK_ABORT(linkage != nullptr);

    const char* src = "int addOne(int x) { return x + 1; }\n"
                      "struct Foo { float a; int b; }\n";
    ComPtr<slang::IBlob> diagnostics;
    slang::IModule* iModule = sessionCom->loadModuleFromSourceString(
        "spikeModule",
        "spikeModule.slang",
        src,
        diagnostics.writeRef());
    SLANG_CHECK_ABORT(iModule != nullptr);

    ModuleDecl* moduleDecl = static_cast<Module*>(iModule)->getModuleDecl();
    SLANG_CHECK_ABORT(moduleDecl != nullptr);

    int funcCount = 0, structCount = 0;
    for (auto member : moduleDecl->getDirectMemberDecls())
    {
        if (as<FuncDecl>(member))
            funcCount++;
        if (as<StructDecl>(member))
            structCount++;
    }
    SLANG_CHECK(funcCount == 1);
    SLANG_CHECK(structCount == 1);
}

//
// ---- Driver. This is the ONLY new machinery; everything above is existing style.
//
namespace
{
class ConsoleReporter : public ITestReporter
{
public:
    int failures = 0;
    const char* current = nullptr;

    void SLANG_MCALL startTest(const char* testName) override
    {
        current = testName;
        printf("  %s\n", testName);
    }
    void SLANG_MCALL addResult(TestResult result) override
    {
        if (result == TestResult::Fail)
            failures++;
    }
    void SLANG_MCALL addResultWithLocation(
        TestResult result,
        const char* testText,
        const char* file,
        int line) override
    {
        addResultWithLocation(result == TestResult::Pass, testText, file, line);
    }
    void SLANG_MCALL
    addResultWithLocation(bool testSucceeded, const char* testText, const char* file, int line)
        override
    {
        if (!testSucceeded)
        {
            failures++;
            printf("    FAIL: %s (%s:%d)\n", testText, file, line);
        }
    }
    void SLANG_MCALL addExecutionTime(double) override {}
    void SLANG_MCALL message(TestMessageType, const char* msg) override
    {
        printf("    %s\n", msg);
    }
    void SLANG_MCALL endTest() override {}
};
} // namespace

extern "C" IUnitTestModule* slangUnitTestGetModule();

int main()
{
    printf("slang-internals-test (existing SLANG_UNIT_TEST style, standalone exe)\n");

    ComPtr<slang::IGlobalSession> globalSession;
    slang_createGlobalSession(SLANG_API_VERSION, globalSession.writeRef());
    if (!globalSession)
        return 1;

    IUnitTestModule* testModule = slangUnitTestGetModule();
    ConsoleReporter reporter;
    testModule->setTestReporter(&reporter);

    UnitTestContext context = {};
    context.slangGlobalSession = globalSession.get();
    context.workDirectory = ".";
    context.executableDirectory = ".";

    const SlangInt count = testModule->getTestCount();
    printf("discovered %d test(s) via static registration\n", (int)count);
    for (SlangInt i = 0; i < count; i++)
    {
        reporter.startTest(testModule->getTestName(i));
        testModule->getTestFunc(i)(&context);
        reporter.endTest();
    }

    printf(
        "%s (%d failure(s))\n",
        reporter.failures == 0 ? "ALL PASSED" : "FAILED",
        reporter.failures);
    return reporter.failures == 0 ? 0 : 1;
}
