#include <slang-rhi.h>
#include <slang-rhi/shader-cursor.h>
#include <slang-com-ptr.h>
#include <slang.h>

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

using Slang::ComPtr;
using namespace rhi;

namespace
{

constexpr uint32_t kCoverageBinding = 11;
constexpr uint32_t kCoverageSpace = 3;
constexpr uint32_t kDispatchCount = 64;

[[noreturn]] void fail(const std::string& message)
{
    std::cerr << "error: " << message << "\n";
    std::exit(1);
}

void check(Result result, const char* what)
{
    if (SLANG_FAILED(result))
        fail(std::string(what) + " failed");
}

void checkSlang(SlangResult result, const char* what)
{
    if (SLANG_FAILED(result))
        fail(std::string(what) + " failed");
}

void diagnoseIfNeeded(slang::IBlob* diagnostics)
{
    if (diagnostics && diagnostics->getBufferSize())
    {
        std::cerr.write(reinterpret_cast<const char*>(diagnostics->getBufferPointer()), diagnostics->getBufferSize());
        std::cerr << "\n";
    }
}

struct SyntheticCoverageProgram
{
    ComPtr<IShaderProgram> program;
    ComPtr<slang::IMetadata> metadata;
    slang::ICoverageTracingMetadata* coverageMetadata = nullptr;
    slang::ISyntheticResourceMetadata* syntheticMetadata = nullptr;
    std::vector<SyntheticResourceBindingDesc> syntheticResources;
};

std::filesystem::path getDemoDirectory()
{
    return std::filesystem::path(__FILE__).parent_path();
}

const std::string& getDemoSearchPath()
{
    static const std::string path = getDemoDirectory().string();
    return path;
}

std::filesystem::path getOutputDirectory()
{
    return std::filesystem::current_path();
}

SyntheticResourceScope mapScope(slang::SyntheticResourceScope scope)
{
    switch (scope)
    {
    case slang::SyntheticResourceScope::Global:
        return SyntheticResourceScope::Global;
    case slang::SyntheticResourceScope::EntryPoint:
        return SyntheticResourceScope::EntryPoint;
    default:
        fail("unhandled synthetic resource scope");
    }
}

SyntheticResourceAccess mapAccess(slang::SyntheticResourceAccess access)
{
    switch (access)
    {
    case slang::SyntheticResourceAccess::Read:
        return SyntheticResourceAccess::Read;
    case slang::SyntheticResourceAccess::Write:
        return SyntheticResourceAccess::Write;
    case slang::SyntheticResourceAccess::ReadWrite:
        return SyntheticResourceAccess::ReadWrite;
    default:
        fail("unhandled synthetic resource access");
    }
}

ComPtr<IDevice> createVulkanDevice(ComPtr<slang::IGlobalSession>& outGlobalSession)
{
    checkSlang(slang::createGlobalSession(outGlobalSession.writeRef()), "createGlobalSession");

    std::vector<slang::CompilerOptionEntry> compilerOptions;
    const char* searchPaths[] = {getDemoSearchPath().c_str()};

    slang::CompilerOptionEntry traceCoverage = {};
    traceCoverage.name = slang::CompilerOptionName::TraceCoverage;
    traceCoverage.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverage.value.intValue0 = 1;
    compilerOptions.push_back(traceCoverage);

    slang::CompilerOptionEntry traceCoverageBinding = {};
    traceCoverageBinding.name = slang::CompilerOptionName::TraceCoverageBinding;
    traceCoverageBinding.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverageBinding.value.intValue0 = kCoverageBinding;
    traceCoverageBinding.value.intValue1 = kCoverageSpace;
    compilerOptions.push_back(traceCoverageBinding);

    slang::CompilerOptionEntry emitSpirvDirectly = {};
    emitSpirvDirectly.name = slang::CompilerOptionName::EmitSpirvDirectly;
    emitSpirvDirectly.value.kind = slang::CompilerOptionValueKind::Int;
    emitSpirvDirectly.value.intValue0 = 1;
    compilerOptions.push_back(emitSpirvDirectly);

    DeviceDesc desc = {};
    desc.deviceType = DeviceType::Vulkan;
    desc.slang.slangGlobalSession = outGlobalSession;
    desc.slang.searchPaths = searchPaths;
    desc.slang.searchPathCount = 1;
    desc.slang.compilerOptionEntries = compilerOptions.data();
    desc.slang.compilerOptionEntryCount = (uint32_t)compilerOptions.size();

    ComPtr<IDevice> device;
    check(getRHI()->createDevice(desc, device.writeRef()), "createDevice(Vulkan)");
    return device;
}

SyntheticCoverageProgram createCoverageProgram(IDevice* device, slang::IGlobalSession* globalSession)
{
    SyntheticCoverageProgram result;

    slang::TargetDesc targetDesc = {};
    targetDesc.format = SLANG_SPIRV;
    targetDesc.profile = globalSession->findProfile("spirv_1_5");

    std::vector<slang::CompilerOptionEntry> compilerOptions;

    slang::CompilerOptionEntry traceCoverage = {};
    traceCoverage.name = slang::CompilerOptionName::TraceCoverage;
    traceCoverage.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverage.value.intValue0 = 1;
    compilerOptions.push_back(traceCoverage);

    slang::CompilerOptionEntry traceCoverageBinding = {};
    traceCoverageBinding.name = slang::CompilerOptionName::TraceCoverageBinding;
    traceCoverageBinding.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverageBinding.value.intValue0 = kCoverageBinding;
    traceCoverageBinding.value.intValue1 = kCoverageSpace;
    compilerOptions.push_back(traceCoverageBinding);

    slang::SessionDesc sessionDesc = {};
    sessionDesc.targets = &targetDesc;
    sessionDesc.targetCount = 1;
    sessionDesc.compilerOptionEntries = compilerOptions.data();
    sessionDesc.compilerOptionEntryCount = (uint32_t)compilerOptions.size();

    ComPtr<slang::ISession> slangSession;
    checkSlang(globalSession->createSession(sessionDesc, slangSession.writeRef()), "createSession");

    ComPtr<slang::IBlob> diagnostics;
    const std::string appPath = (getDemoDirectory() / "app.slang").string();
    slang::IModule* loadedModule = slangSession->loadModule(appPath.c_str(), diagnostics.writeRef());
    diagnoseIfNeeded(diagnostics);
    if (!loadedModule)
        fail("loadModule(app.slang) returned null");
    ComPtr<slang::IModule> module(loadedModule);

    std::vector<ComPtr<slang::IComponentType>> components;
    components.push_back(ComPtr<slang::IComponentType>(module.get()));

    ComPtr<slang::IEntryPoint> entryPoint;
    checkSlang(module->findEntryPointByName("computeMain", entryPoint.writeRef()), "findEntryPointByName");
    if (!entryPoint)
        fail("entry point computeMain not found");
    components.push_back(ComPtr<slang::IComponentType>(entryPoint.get()));

    std::vector<slang::IComponentType*> rawComponents;
    rawComponents.reserve(components.size());
    for (auto& component : components)
        rawComponents.push_back(component.get());

    diagnostics.setNull();
    ComPtr<slang::IComponentType> composedProgram;
    checkSlang(
        slangSession->createCompositeComponentType(
            rawComponents.data(),
            rawComponents.size(),
            composedProgram.writeRef(),
            diagnostics.writeRef()),
        "createCompositeComponentType");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    ComPtr<slang::IComponentType> linkedProgram;
    checkSlang(composedProgram->link(linkedProgram.writeRef(), diagnostics.writeRef()), "link");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    ComPtr<slang::IBlob> entryPointCode;
    checkSlang(linkedProgram->getEntryPointCode(0, 0, entryPointCode.writeRef(), diagnostics.writeRef()), "getEntryPointCode");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    checkSlang(linkedProgram->getEntryPointMetadata(0, 0, result.metadata.writeRef(), diagnostics.writeRef()), "getEntryPointMetadata");
    diagnoseIfNeeded(diagnostics);

    result.coverageMetadata = (slang::ICoverageTracingMetadata*)result.metadata->castAs(
        slang::ICoverageTracingMetadata::getTypeGuid());
    result.syntheticMetadata = (slang::ISyntheticResourceMetadata*)result.metadata->castAs(
        slang::ISyntheticResourceMetadata::getTypeGuid());
    if (!result.coverageMetadata || !result.syntheticMetadata)
        fail("expected coverage + synthetic metadata");

    const uint32_t resourceCount = result.syntheticMetadata->getResourceCount();
    result.syntheticResources.reserve(resourceCount);
    for (uint32_t i = 0; i < resourceCount; ++i)
    {
        slang::SyntheticResourceInfo info = {};
        checkSlang(result.syntheticMetadata->getResourceInfo(i, &info), "getResourceInfo");

        SyntheticResourceBindingDesc desc = {};
        desc.id = info.id;
        desc.bindingType = info.bindingType;
        desc.arraySize = info.arraySize;
        desc.scope = mapScope(info.scope);
        desc.access = mapAccess(info.access);
        desc.entryPointIndex = info.entryPointIndex;
        desc.space = info.space;
        desc.binding = info.binding;
        desc.uniformOffset = info.uniformOffset;
        desc.uniformStride = info.uniformStride;
        desc.debugName = info.debugName;
        result.syntheticResources.push_back(desc);
    }

    ShaderProgramSyntheticResourcesDesc syntheticDesc = {};
    syntheticDesc.resources = result.syntheticResources.data();
    syntheticDesc.resourceCount = (uint32_t)result.syntheticResources.size();

    ShaderProgramDesc programDesc = {};
    programDesc.slangGlobalScope = linkedProgram;
    programDesc.next = &syntheticDesc;

    diagnostics.setNull();
    check(device->createShaderProgram(programDesc, result.program.writeRef(), diagnostics.writeRef()), "createShaderProgram");
    diagnoseIfNeeded(diagnostics);

    return result;
}

ComPtr<IBuffer> createBuffer(
    IDevice* device,
    size_t size,
    BufferUsage usage,
    ResourceState defaultState,
    const void* initialData = nullptr)
{
    BufferDesc desc = {};
    desc.size = size;
    desc.format = Format::Undefined;
    desc.elementSize = sizeof(uint32_t);
    desc.usage = usage;
    desc.defaultState = defaultState;
    desc.memoryType = MemoryType::DeviceLocal;

    ComPtr<IBuffer> buffer;
    check(device->createBuffer(desc, initialData, buffer.writeRef()), "createBuffer");
    return buffer;
}

int writeLcovReport(
    slang::ICoverageTracingMetadata* coverage,
    const std::vector<uint32_t>& hits,
    const std::filesystem::path& outputPath)
{
    const uint32_t counterCount = coverage->getCounterCount();
    if (hits.size() != counterCount)
        return -1;

    std::map<std::string, std::map<uint32_t, uint64_t>> byFile;
    for (uint32_t i = 0; i < counterCount; ++i)
    {
        slang::CoverageEntryInfo entry = {};
        if (SLANG_FAILED(coverage->getEntryInfo(i, &entry)))
            continue;
        if (!entry.file || !*entry.file || entry.line == 0)
            continue;
        byFile[entry.file][entry.line] += hits[i];
    }

    std::ofstream file(outputPath, std::ios::binary);
    if (!file)
        return -1;

    file << "TN:slang-rhi-coverage-demo\n";
    for (const auto& filePair : byFile)
    {
        file << "SF:" << filePair.first << "\n";
        for (const auto& linePair : filePair.second)
            file << "DA:" << linePair.first << "," << linePair.second << "\n";
        file << "end_of_record\n";
    }
    return 0;
}

std::vector<uint32_t> readUintBuffer(IDevice* device, IBuffer* buffer, size_t count)
{
    ComPtr<ISlangBlob> data;
    check(device->readBuffer(buffer, 0, count * sizeof(uint32_t), data.writeRef()), "readBuffer");
    const auto* ptr = static_cast<const uint32_t*>(data->getBufferPointer());
    return std::vector<uint32_t>(ptr, ptr + count);
}

} // namespace

int main()
{
    std::cout << "creating Vulkan device\n";
    ComPtr<slang::IGlobalSession> globalSession;
    auto device = createVulkanDevice(globalSession);

    std::cout << "compiling coverage-enabled shader through slang-rhi\n";
    auto program = createCoverageProgram(device.get(), globalSession.get());
    if (program.syntheticResources.size() != 1)
        fail("expected exactly one synthetic resource");

    const auto& coverageResource = program.syntheticResources[0];
    std::cout << "synthetic coverage resource: id=" << coverageResource.id
              << " set=" << coverageResource.space
              << " binding=" << coverageResource.binding
              << " uniformOffset=" << coverageResource.uniformOffset
              << " uniformStride=" << coverageResource.uniformStride << "\n";

    slang::SyntheticResourceDescriptorRange descriptorRange = {};
    checkSlang(
        slang::findSyntheticResourceDescriptorRangeByID(
            program.syntheticMetadata,
            coverageResource.id,
            &descriptorRange),
        "findSyntheticResourceDescriptorRangeByID");
    if (descriptorRange.space != (int32_t)kCoverageSpace || descriptorRange.binding != (int32_t)kCoverageBinding)
        fail("descriptor helper reported unexpected binding");

    slang::CoverageBufferInfo bufferInfo = {};
    checkSlang(program.coverageMetadata->getBufferInfo(&bufferInfo), "getBufferInfo");
    const uint32_t counterCount = program.coverageMetadata->getCounterCount();
    if (counterCount == 0)
        fail("counterCount is zero");

    std::cout << "coverage buffer elements: " << counterCount << "\n";

    ComputePipelineDesc pipelineDesc = {};
    pipelineDesc.program = program.program;
    auto pipeline = device->createComputePipeline(pipelineDesc);
    if (!pipeline)
        fail("createComputePipeline returned null");

    auto rootObject = device->createRootShaderObject(pipeline.get());
    if (!rootObject)
        fail("createRootShaderObject returned null");

    const auto outputDir = getOutputDirectory();
    std::vector<uint32_t> zeroCoverage(counterCount, 0u);
    std::vector<uint32_t> zeroOutput(kDispatchCount, 0u);

    auto coverageBuffer = createBuffer(
        device.get(),
        zeroCoverage.size() * sizeof(uint32_t),
        BufferUsage::ShaderResource | BufferUsage::UnorderedAccess | BufferUsage::CopySource | BufferUsage::CopyDestination,
        ResourceState::UnorderedAccess,
        zeroCoverage.data());
    auto outputBuffer = createBuffer(
        device.get(),
        zeroOutput.size() * sizeof(uint32_t),
        BufferUsage::ShaderResource | BufferUsage::UnorderedAccess | BufferUsage::CopySource | BufferUsage::CopyDestination,
        ResourceState::UnorderedAccess,
        zeroOutput.data());

    ShaderCursor(rootObject.get())["outBuffer"].setBinding(outputBuffer);
    check(
        bindSyntheticResource(
            program.program.get(),
            rootObject.get(),
            coverageResource.id,
            Binding(coverageBuffer)),
        "bindSyntheticResource");

    auto queue = device->getQueue(QueueType::Graphics);
    auto encoder = queue->createCommandEncoder();
    auto pass = encoder->beginComputePass();
    pass->bindPipeline(pipeline, rootObject);
    pass->dispatchCompute(kDispatchCount, 1, 1);
    pass->end();
    check(queue->submit(encoder->finish()), "queue->submit");
    check(queue->waitOnHost(), "queue->waitOnHost");

    const auto outputValues = readUintBuffer(device.get(), outputBuffer.get(), kDispatchCount);
    for (uint32_t i = 0; i < kDispatchCount; ++i)
    {
        const uint32_t expectedValue = i * 3u;
        if (outputValues[i] != expectedValue)
            fail("unexpected compute result");
    }
    std::cout << "output buffer verified for " << kDispatchCount << " dispatches\n";

    const auto coverageValues = readUintBuffer(device.get(), coverageBuffer.get(), counterCount);
    uint64_t totalHits = 0;
    uint32_t coveredLineCount = 0;
    uint32_t uncoveredLineCount = 0;
    std::map<std::string, std::map<uint32_t, uint64_t>> byFile;
    for (uint32_t i = 0; i < counterCount; ++i)
    {
        totalHits += coverageValues[i];

        slang::CoverageEntryInfo entry = {};
        checkSlang(program.coverageMetadata->getEntryInfo(i, &entry), "getEntryInfo");
        if (!entry.file || !*entry.file || entry.line == 0)
            continue;
        byFile[entry.file][entry.line] += coverageValues[i];
    }

    bool sawApp = false;
    bool sawPhysics = false;
    bool sawMath = false;

    for (const auto& filePair : byFile)
    {
        const std::string fileName = std::filesystem::path(filePair.first).filename().string();
        if (fileName == "app.slang")
            sawApp = true;
        else if (fileName == "physics.slang")
            sawPhysics = true;
        else if (fileName == "math.slang")
            sawMath = true;

        for (const auto& linePair : filePair.second)
        {
            if (linePair.second > 0)
                ++coveredLineCount;
            else
                ++uncoveredLineCount;
        }
    }

    if (totalHits == 0 || coveredLineCount == 0 || uncoveredLineCount == 0)
        fail("coverage counters do not show both covered and uncovered lines");
    if (!(sawApp && sawPhysics && sawMath))
        fail("coverage metadata did not attribute lines across all demo modules");

    std::cout << "aggregate coverage hits = " << totalHits << "\n";
    std::cout << "covered lines = " << coveredLineCount
              << ", uncovered lines = " << uncoveredLineCount << "\n";
    std::cout << "attributed files: "
              << (sawApp ? "app " : "")
              << (sawPhysics ? "physics " : "")
              << (sawMath ? "math" : "") << "\n";

    {
        ComPtr<ISlangBlob> manifestBlob;
        checkSlang(
            slang_writeCoverageManifestJson(program.coverageMetadata, manifestBlob.writeRef()),
            "slang_writeCoverageManifestJson");
        std::ofstream manifest(outputDir / "slang-rhi-coverage-demo.coverage-mapping.json", std::ios::binary);
        manifest.write(
            static_cast<const char*>(manifestBlob->getBufferPointer()),
            (std::streamsize)manifestBlob->getBufferSize());
    }
    if (writeLcovReport(
            program.coverageMetadata,
            coverageValues,
            outputDir / "slang-rhi-coverage-demo.lcov") != 0)
    {
        fail("writeLcovReport failed");
    }

    std::cout << "wrote "
              << (outputDir / "slang-rhi-coverage-demo.coverage-mapping.json") << "\n";
    std::cout << "wrote " << (outputDir / "slang-rhi-coverage-demo.lcov") << "\n";
    std::cout << "demo completed successfully\n";
    return 0;
}
