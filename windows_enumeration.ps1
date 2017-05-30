$erroractionPreference="SilentlyContinue"
foreach($drive in Get-PSDrive -PSProvider 'FileSystem' ){
    foreach($item in Get-ChildItem  -Recurse $drive.Root){
        $acl = Get-Acl $item.FullName -ErrorAction Stop
        $acl_access = Get-Acl C:  | Select-Object -ExpandProperty Access
        $user_acl_result = ""
        foreach($i in $acl_access){
            $data = $i.AccessControlType,$i.FileSystemRights,$i.IdentityReference,$i.InheritanceFlags,$i.IsInherited,$i.PropagationFlags
            $user_acl_result +=[String]::Join(":",$data)+";"
        }
        $item | Select-Object -Property Attributes, CreationTime, FullName, Extension, IsReadOnly, LastAccessTime, LastWriteTime, Length, Name,@{Name="Owner";Expression={$acl.Owner}},@{Name="Group";Expression={$acl.Group}},@{Name="Audit";Expression={$acl.Audit}},@{Name="ACL Access";Expression={$user_acl_result}}| ConvertTo-Csv -NoTypeInformation| Select-Object -Skip 1 | Out-File -Append ownership_and_permissions.csv
    }
}
