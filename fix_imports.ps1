$files = Get-Content files_to_fix.txt
foreach ($file in $files) {
    if ($file -match "hakim_spacing.dart") { continue }
    if (-not (Test-Path $file)) { continue }
    $content = Get-Content $file -Raw
    if ($content -match "HakimSpacing" -and $content -notmatch "import.*hakim_spacing.dart") {
        if ($content -match "import.*hakim_colors.dart") {
            # Check if it has the relative import or package import
            if ($content -match "import '.*hakim_colors.dart'") {
                 # Match relative import
                 $content = $content -replace "(import '.*hakim_colors.dart';?\r?\n)", "`$1import 'package:hakeem/core/constants/hakim_spacing.dart';`r`n"
            } elseif ($content -match "import `".*hakim_colors.dart`"") {
                 # Match relative import with double quotes
                 $content = $content -replace "(import `".*hakim_colors.dart`";?\r?\n)", "`$1import 'package:hakeem/core/constants/hakim_spacing.dart';`r`n"
            }
        } else {
            # Find the last import
            $lines = $content -split "\r?\n"
            $lastImportIndex = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match "^import ") {
                    $lastImportIndex = $i
                }
            }
            if ($lastImportIndex -ne -1) {
                $newLines = @()
                for ($i = 0; $i -le $lastImportIndex; $i++) { $newLines += $lines[$i] }
                $newLines += "import 'package:hakeem/core/constants/hakim_spacing.dart';"
                for ($i = $lastImportIndex + 1; $i -lt $lines.Count; $i++) { $newLines += $lines[$i] }
                $content = $newLines -join "`r`n"
            } else {
                # No imports found, prepend
                $content = "import 'package:hakeem/core/constants/hakim_spacing.dart';`r`n" + $content
            }
        }
        Set-Content $file $content
        Write-Host "Fixed $file"
    }
}
