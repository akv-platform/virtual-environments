param(
    [String] [Parameter (Mandatory = $True)] $BuildId,
    [String] [Parameter (Mandatory = $True)] $Organization,
    [String] [Parameter (Mandatory = $True)] $Project,
    [String] [Parameter (Mandatory = $True)] $ImageName,
    [String] [Parameter (Mandatory = $True)] $DefinitionId,
    [String] [Parameter (Mandatory = $True)] $AccessToken
)

$Body = @{
    definitionId = $DefinitionId
    variables = {
      ImageBuildId = {
        value = $BuildId
      }
      ImageName = {
        value = $ImageName
      }
    }
    isDraft = "false"
} | ConvertTo-Json
Write-Host $Body
$URL = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/releases?api-version=5.1"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("'':${AccessToken}"))
$headers = @{
    Authorization = "Basic ${base64AuthInfo}"
}

$params = @{
    Method = "POST"
    ContentType = "application/json"
    Uri = $URL
    Headers = $headers
    Body = $Body
}

$pipeline = Invoke-RestMethod -Uri $URL -Headers $headers
$pipeline.value | ForEach-Object {
  Write-Host $_ | Format-List | Out-String
}

$NewRelease = Invoke-RestMethod @params



Write-Host "Created release: $($NewRelease.release._links.web.refs)"
