---
external help file: CosmosDB-help.xml
Module Name: CosmosDB
online version:
schema: 2.0.0
---

# Remove-CosmosDbDocument

## SYNOPSIS

Delete a document from a CosmosDB collection.

## SYNTAX

### Context (Default)

```powershell
Remove-CosmosDbDocument -Context <Context> [-Database <String>] [-Key <SecureString>] [-KeyType <String>]
 -CollectionId <String> [-Id <String>] [-PartitionKey <String>] [<CommonParameters>]
```

### Account

```powershell
Remove-CosmosDbDocument -Account <String> [-Database <String>] [-Key <SecureString>] [-KeyType <String>]
 -CollectionId <String> [-Id <String>] [-PartitionKey <String>] [<CommonParameters>]
```

## DESCRIPTION

This cmdlet will delete a document in a CosmosDB from a collection.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-CosmosDbDocument -Context $cosmosDbContext -CollectionId 'MyNewCollection' -Id 'ac12345'
```

Delete a document from a collection in the database.

## PARAMETERS

### -Context

This is an object containing the context information of the CosmosDB database
that will be deleted. It should be created by \`New-CosmosDbContext\`.

```yaml
Type: Context
Parameter Sets: Context
Aliases: Connection

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Account

The account name of the CosmosDB to access.

```yaml
Type: String
Parameter Sets: Account
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database

The name of the database to access in the CosmosDB account.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key

The key to be used to access this CosmosDB.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyType

The type of key that will be used to access ths CosmosDB.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Master
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionId

This is the Id of the collection to delete the document from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

This is the Id of the document to delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PartitionKey

The partition key value for the document to be deleted.
Must be included if and only if the collection is created with a
partitionKey definition.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
