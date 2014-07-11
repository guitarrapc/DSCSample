@{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDSCAllowPlainTextPassword = $true
        }
        @{
            NodeName = "10.0.2.20"
            Role     = "DSCServer"
        }
        
        @{
            NodeName = "10.0.2.11"
            Role     = "pull"
        }
    )
}