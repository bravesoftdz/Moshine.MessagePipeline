﻿<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <RootNamespace>TestHostConsoleApplication</RootNamespace>
    <ProjectGuid>{7d1fb0a8-9368-4648-b1c2-9902faddc82c}</ProjectGuid>
    <OutputType>Exe</OutputType>
    <AssemblyName>TestHostConsoleApplication</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <ApplicationIcon>Properties\App.ico</ApplicationIcon>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <TargetFrameworkVersion>v4.5.2</TargetFrameworkVersion>
    <Name>TestHostConsoleApplication</Name>
    <DefaultUses />
    <StartupClass />
    <InternalAssemblyName />
    <TargetFrameworkProfile />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GeneratePDB>True</GeneratePDB>
    <GenerateMDB>True</GenerateMDB>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GeneratePDB>False</GeneratePDB>
    <GenerateMDB>False</GenerateMDB>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Microsoft.ServiceBus">
      <HintPath>..\packages\WindowsAzure.ServiceBus.3.1.7\lib\net45-full\Microsoft.ServiceBus.dll</HintPath>
      <Private>True</Private>
    </Reference>
    <Reference Include="Microsoft.WindowsAzure.Configuration">
      <HintPath>..\packages\Microsoft.WindowsAzure.ConfigurationManager.2.0.3\lib\net40\Microsoft.WindowsAzure.Configuration.dll</HintPath>
      <Private>True</Private>
    </Reference>
    <Reference Include="mscorlib" />
    <Reference Include="Echoes">
      <HintPath>C:\Program Files\RemObjects Software\Oxygene\Echoes\Reference Assemblies\RemObjects.Elements.Dynamic.dll</HintPath>
    </Reference>
    <Reference Include="RemObjects.Elements.EUnit">
      <HintPath>C:\Program Files\RemObjects Software\Oxygene\EUnit\Echoes\RemObjects.Elements.EUnit.dll</HintPath>
    </Reference>
    <Reference Include="System" />
    <Reference Include="System.Configuration">
      <HintPath>C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.Configuration.dll</HintPath>
    </Reference>
    <Reference Include="System.Data" />
    <Reference Include="System.Runtime.Serialization" />
    <Reference Include="System.ServiceModel" />
    <Reference Include="System.Xml" />
    <Reference Include="System.Core">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
    <Reference Include="System.Xml.Linq">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
    <Reference Include="System.Data.DataSetExtensions">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Program.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
    <Compile Include="Services\ServiceClass.pas" />
    <Compile Include="Tests\SerializerTests.pas" />
    <Compile Include="Tests\Transport\InMemoryTests.pas" />
    <Compile Include="Tests\Transport\ServiceBusTests.pas" />
    <Compile Include="Transport\InMemoryBus.pas" />
    <Content Include="App.config">
      <SubType>Content</SubType>
    </Content>
    <Content Include="packages.config">
      <SubType>Content</SubType>
    </Content>
    <Content Include="Properties\App.ico" />
    <EmbeddedResource Include="Properties\Resources.resx">
      <Generator>ResXFileCodeGenerator</Generator>
    </EmbeddedResource>
    <Compile Include="Properties\Resources.Designer.pas" />
    <None Include="Properties\Settings.settings">
      <Generator>SettingsSingleFileGenerator</Generator>
    </None>
    <Compile Include="Properties\Settings.Designer.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Tests\Transport\" />
    <Folder Include="Transport" />
    <Folder Include="Services" />
    <Folder Include="Tests" />
    <Folder Include="Properties\" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Moshine.MessagePipeline.Core\Moshine.MessagePipeline.Core.elements">
      <Name>Moshine.MessagePipeline.Core</Name>
      <Project>{d6fddd36-602c-49c1-b399-30852f6f8b98}</Project>
      <Private>True</Private>
      <HintPath>..\Moshine.MessagePipeline.Core\bin\Debug\Moshine.MessagePipeline.Core.dll</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Moshine.MessagePipeline.Transports.ServiceBus\Moshine.MessagePipeline.Transports.ServiceBus.elements">
      <Name>Moshine.MessagePipeline.Transports.ServiceBus</Name>
      <Project>{5341e3c0-40ef-415c-9517-eb3c8a2eff98}</Project>
      <Private>True</Private>
      <HintPath>..\Moshine.MessagePipeline.Transports.ServiceBus\bin\Debug\Moshine.MessagePipeline.Transports.ServiceBus.dll</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Moshine.MessagePipeline\Moshine.MessagePipeline.oxygene">
      <Name>Moshine.MessagePipeline</Name>
      <Project>{5116edc8-7bf4-4a3b-ba8b-9f875f54fab0}</Project>
      <Private>True</Private>
      <HintPath>..\Moshine.MessagePipeline\bin\Debug\Moshine.MessagePipeline.dll</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Elements\RemObjects.Elements.Echoes.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>