param (
    [Parameter(Mandatory = $true)]
    [String]
    $KeyId,
    [Parameter(Mandatory = $true)]
    [String]
    $SecretArn
)

$secretString = (New-Guid).Guid
$encryptedSecretString = $secretString # will encrypt with KMS
awslocal secretsmanager put-secret-value --secret-string $encryptedSecretString --secret-id $SecretArn