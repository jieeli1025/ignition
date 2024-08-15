# Define variables
$domainName = "Core.Ignition"
$domainUser = "AD1@Core.Ignition"
$domainPassword = "P@ssw0rd1234"
$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($domainUser, $securePassword)

# Log the domain join attempt
Write-Output "Attempting to join domain '$domainName' with user '$domainUser'."

# Join the domain with retry logic
$maxRetries = 3
$retryCount = 0
$success = $false

while ($retryCount -lt $maxRetries -and -not $success) {
    try {
        Add-Computer -DomainName $domainName -Credential $credential -Force -Restart
        Write-Output "Successfully joined the domain '$domainName'."
        $success = $true
    } catch {
        $retryCount++
        Write-Warning "Attempt $retryCount failed: $_"
        if ($retryCount -lt $maxRetries) {
            Write-Output "Retrying in 10 seconds..."
            Start-Sleep -Seconds 10
        } else {
            Write-Error "Failed to join the domain '$domainName' after $retryCount attempts."
        }
    }
}
