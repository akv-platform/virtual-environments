param(
    [String] [Parameter (Mandatory = $True)] $BuildId,
    [String] [Parameter (Mandatory = $True)] $Organization,
    [String] [Parameter (Mandatory = $True)] $Project,
    [String] [Parameter (Mandatory = $True)] $ImageName,
    [String] [Parameter (Mandatory = $True)] $DefinitionId
)

$Body = @{
    definitionId = $DefinitionId
    variables = {
        ImageBuildId = $BuildId
        ImageName = $ImageName
    }
    isDraft = "false"
}

$URL = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/releases?api-version=5.1"
$NewRelease = Invoke-WebRequest $URL -Body $Body -Method "POST"

Write-Host "Created release: $($NewRelease.release._links.web.refs)"