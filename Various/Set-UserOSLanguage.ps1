$targetCulture = "de-CH"
Set-WinSystemLocale $targetCulture
Set-Culture $targetCulture
Set-WinHomeLocation -GeoId 223
Set-WinUserLanguageList $targetCulture -Force