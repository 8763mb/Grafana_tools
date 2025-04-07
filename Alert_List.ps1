$jsonPath = "alert-rules-1743489886437.json"
# .NET JsonSerializer
Add-Type -AssemblyName System.Web.Extensions
$jsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$jsonSerializer.MaxJsonLength = 67108864 # 64MB
$fileContent = Get-Content -Path $jsonPath -Raw -Encoding UTF8
# 檢查 JSON 有效性並進行修正嘗試
$fileContent = $fileContent -replace '(?<!(true|false|null|\d|")\s*),\s*(\}|\])', '$2'
try {
    $jsonContent = $fileContent | ConvertFrom-Json
}
catch {
    $jsonContent = $jsonSerializer.DeserializeObject($fileContent)
}
# 存儲轉換後資料
$csvData = @()
foreach ($group in $jsonContent.groups) {
    $groupName = $group.name
    $groupFolder = $group.folder
    # Alert rules
    foreach ($rule in $group.rules) {
        $ruleTitle = $rule.title
        $ruleUid = $rule.uid
        # Datasource
        foreach ($dataItem in $rule.data) {
            $datasourceUid = $dataItem.datasourceUid
            $expression = $null
            if ($dataItem.model.PSObject.Properties.Name -contains "expr") {
                $expression = $dataItem.model.expr
            }
            elseif ($dataItem.model.PSObject.Properties.Name -contains "query") {
                $expression = $dataItem.model.query
            }
            if ($expression) {
                $rowData = [PSCustomObject]@{
                    "name"          = $groupName
                    "folder"        = $groupFolder
                    "title"         = $ruleTitle
                    "uid"           = $ruleUid
                    "datasourceUid" = $datasourceUid
                    "expr"          = $expression
                }
                $csvData += $rowData
            }
        }
    }
}
$currentdate = Get-Date -Format "yyyyMMdd"
$csvData | Export-Csv -Path Grafana_List_$currentdate.csv -NoTypeInformation -Encoding UTF8
Write-Host "success: $outputPath"
