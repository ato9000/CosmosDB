[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$ModuleManifestName = 'CosmosDB.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

Import-Module -Name $ModuleManifestPath -Force

InModuleScope CosmosDB {
    # Variables for use in tests
    $script:testAccount = 'testAccount'
    $script:testDatabase = 'testDatabase'
    $script:testKey = 'GFJqJeri2Rq910E0G7PsWoZkzowzbj23Sm9DUWFC0l0P8o16mYyuaZKN00Nbtj9F1QQnumzZKSGZwknXGERrlA=='
    $script:testKeySecureString = ConvertTo-SecureString -String $script:testKey -AsPlainText -Force
    $script:testContext = [CosmosDb.Context] @{
        Account  = $script:testAccount
        Database = $script:testDatabase
        Key      = $script:testKeySecureString
        KeyType  = 'master'
        BaseUri  = ('https://{0}.documents.azure.com/' -f $script:testAccount)
    }
    $script:testCollection1 = 'testCollection1'
    $script:testCollection2 = 'testCollection2'
    $script:testJsonMulti = @'
{
    "_rid": "PaYSAA==",
    "DocumentCollections": [
        {
            "id": "testcollection1"
        },
        {
            "id": "testcollection2"
        }
    ],
    "_count": 1
}
'@
    $script:testJsonSingle = @'
{
    "id": "testcollection1"
}
'@

    Describe 'Get-CosmosDbCollectionResourcePath' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Get-CosmosDbCollectionResourcePath  -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with all parameters' {
            $script:result = $null

            It 'Should not throw exception' {
                $getCosmosDbCollectionResourcePathParameters = @{
                    Database = $script:testDatabase
                    Id       = $script:testCollection1
                }

                { $script:result = Get-CosmosDbCollectionResourcePath @getCosmosDbCollectionResourcePathParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result | Should -Be ('dbs/{0}/colls/{1}' -f $script:testDatabase, $script:testCollection1)
            }
        }
    }

    Describe 'New-CosmosDbCollectionIncludedPathIndex' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-CosmosDbCollectionIncludedPathIndex  -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with all parameters' {
            $script:result = $null

            It 'Should not throw exception' {
                $newCosmosDbCollectionIncludedPathIndexParameters = @{
                    Kind      = 'Hash'
                    DataType  = 'String'
                    Precision = -1
                }

                { $script:result = New-CosmosDbCollectionIncludedPathIndex @newCosmosDbCollectionIncludedPathIndexParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result | Should -BeOfType 'CosmosDB.IndexingPolicy.Path.Index'
                $script:result.Kind | Should -Be 'Hash'
                $script:result.DataType | Should -Be 'String'
                $script:result.Precision | Should -Be -1
            }
        }
    }

    Describe 'New-CosmosDbCollectionIncludedPath' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-CosmosDbCollectionIncludedPath  -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with all parameters' {
            $script:result = $null

            It 'Should not throw exception' {
                $newCosmosDbCollectionIncludedPathParameters = @{
                    Path  = '/*'
                    Index = (New-CosmosDbCollectionIncludedPathIndex -Kind 'Hash' -DataType 'String' -Precision -1)
                }

                { $script:result = New-CosmosDbCollectionIncludedPath @newCosmosDbCollectionIncludedPathParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result | Should -BeOfType 'CosmosDB.IndexingPolicy.Path.IncludedPath'
                $script:result.Path | Should -Be '/*'
                $script:result.Indexes[0].Kind | Should -Be 'Hash'
                $script:result.Indexes[0].DataType | Should -Be 'String'
                $script:result.Indexes[0].Precision | Should -Be -1
            }
        }
    }

    Describe 'New-CosmosDbCollectionExcludedPath' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-CosmosDbCollectionExcludedPath  -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with all parameters' {
            $script:result = $null

            It 'Should not throw exception' {
                $newCosmosDbCollectionExcludedPathParameters = @{
                    Path  = '/*'
                }

                { $script:result = New-CosmosDbCollectionExcludedPath @newCosmosDbCollectionExcludedPathParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result | Should -BeOfType 'CosmosDB.IndexingPolicy.Path.ExcludedPath'
                $script:result.Path | Should -Be '/*'
            }
        }
    }

    Describe 'New-CosmosDbCollectionIndexingPolicy' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-CosmosDbCollectionIndexingPolicy  -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with all parameters' {
            $script:result = $null

            It 'Should not throw exception' {
                $newCosmosDbCollectionIndexingPolicyParameters = @{
                    Automatic = $true
                    IndexingMode = 'Consistent'
                    IncludedPath = (New-CosmosDbCollectionIncludedPath -Path '/*' -Index (New-CosmosDbCollectionIncludedPathIndex -Kind 'Hash' -DataType 'String' -Precision -1))
                    ExcludedPath = (New-CosmosDbCollectionExcludedPath -Path '/*')
                }

                { $script:result = New-CosmosDbCollectionIndexingPolicy @newCosmosDbCollectionIndexingPolicyParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result | Should -BeOfType 'CosmosDB.IndexingPolicy.Policy'
                $script:result.Automatic | Should -Be $true
                $script:result.IndexingMode | Should -Be 'Consistent'
                $script:result.IncludedPaths[0].Path | Should -Be '/*'
                $script:result.ExcludedPaths[0].Path | Should -Be '/*'
            }
        }
    }

    Describe 'Get-CosmosDbCollection' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Get-CosmosDbCollection -ErrorAction Stop } | Should -Not -Throw
        }

        BeforeEach {
            Mock -CommandName Set-CosmosDbCollectionType -MockWith { $Collection }
        }

        Context 'When called with context parameter and no Id' {
            $script:result = $null

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter { $Method -eq 'Get' -and $ResourceType -eq 'colls' } `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonMulti }

            It 'Should not throw exception' {
                $getCosmosDbCollectionParameters = @{
                    Context = $script:testContext
                }

                { $script:result = Get-CosmosDbCollection @getCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result.Count | Should -Be 2
                $script:result[0].id | Should -Be $script:testCollection1
                $script:result[1].id | Should -Be $script:testCollection2
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter { $Method -eq 'Get' -and $ResourceType -eq 'colls' } `
                    -Exactly -Times 1
            }
        }

        Context 'When called with context parameter and an Id' {
            $script:result = $null

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter { $Method -eq 'Get' -and $ResourceType -eq 'colls' -and $ResourcePath -eq ('colls/{0}' -f $script:testCollection1) } `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonSingle }

            It 'Should not throw exception' {
                $getCosmosDbCollectionParameters = @{
                    Context = $script:testContext
                    Id      = $script:testCollection1
                }

                { $script:result = Get-CosmosDbCollection @getCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result.id | Should -Be $script:testCollection1
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter { $Method -eq 'Get' -and $ResourceType -eq 'colls' -and $ResourcePath -eq ('colls/{0}' -f $script:testCollection1) } `
                    -Exactly -Times 1
            }
        }
    }

    Describe 'New-CosmosDbCollection' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-CosmosDbCollection -ErrorAction Stop } | Should -Not -Throw
        }

        BeforeEach {
            Mock -CommandName Set-CosmosDbCollectionType -MockWith { $Collection }
        }

        Context 'When called with context parameter and an Id' {
            $invokecosmosdbrequest_parameterfilter = {
                $Method -eq 'Post' -and `
                    $ResourceType -eq 'colls' -and `
                    $Body -eq (ConvertTo-Json -Depth 10 -InputObject @{ id = $script:testCollection1 } )
            }
            $script:result = $null

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonSingle }

            It 'Should not throw exception' {
                $newCosmosDbCollectionParameters = @{
                    Context = $script:testContext
                    Id      = $script:testCollection1
                }

                { $script:result = New-CosmosDbCollection @newCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result.id | Should -Be $script:testCollection1
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                    -Exactly -Times 1
            }
        }

        Context 'When called with context parameter and an Id and OfferThroughput parameter' {
            $script:result = $null
            $invokecosmosdbrequest_parameterfilter = {
                $Method -eq 'Post' -and `
                    $ResourceType -eq 'colls' -and `
                    $Body -eq (ConvertTo-Json -Depth 10 -InputObject @{ id = $script:testCollection1 } ) -and `
                    $Headers['x-ms-offer-throughput'] -eq 400
            }

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonSingle }

            It 'Should not throw exception' {
                $newCosmosDbCollectionParameters = @{
                    Context         = $script:testContext
                    Id              = $script:testCollection1
                    OfferThroughput = 400
                }

                { $script:result = New-CosmosDbCollection @newCosmosDbCollectionParameters } | Should -Not -Throw
            }
            It 'Should return expected result' {
                $script:result.id | Should -Be $script:testCollection1
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                    -Exactly -Times 1
            }
        }

        Context 'When called with context parameter and an Id and OfferType parameter' {
            $script:result = $null
            $invokecosmosdbrequest_parameterfilter = {
                $Method -eq 'Post' -and `
                    $ResourceType -eq 'colls' -and `
                    $Body -eq (ConvertTo-Json -Depth 10 -InputObject @{ id = $script:testCollection1 } ) -and `
                    $Headers['x-ms-offer-type'] -eq 'S2'
            }

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonSingle }

            It 'Should not throw exception' {
                $newCosmosDbCollectionParameters = @{
                    Context   = $script:testContext
                    Id        = $script:testCollection1
                    OfferType = 'S2'
                }

                { $script:result = New-CosmosDbCollection @newCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result.id | Should -Be $script:testCollection1
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                    -Exactly -Times 1
            }
        }

        Context 'When called with context parameter and an Id and PartitionKey parameter' {
            $script:result = $null
            $invokecosmosdbrequest_parameterfilter = {
                $Method -eq 'Post' -and `
                    $ResourceType -eq 'colls' -and `
                    $Body -eq (ConvertTo-Json -Depth 10 -InputObject @{
                        id           = $script:testCollection1
                        partitionKey = @{
                            paths = @('/partitionkey')
                            kind  = 'Hash'
                        }
                    })
            }

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonSingle }

            It 'Should not throw exception' {
                $newCosmosDbCollectionParameters = @{
                    Context      = $script:testContext
                    Id           = $script:testCollection1
                    PartitionKey = 'partitionkey'
                }

                { $script:result = New-CosmosDbCollection @newCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should return expected result' {
                $script:result.id | Should -Be $script:testCollection1
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter $invokecosmosdbrequest_parameterfilter `
                    -Exactly -Times 1
            }
        }

        Context 'When called with context parameter and an Id and OfferType and OfferThrougput' {
            $script:result = $null

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -MockWith { ConvertFrom-Json -InputObject $script:testJsonMulti }

            It 'Should not throw exception' {
                $newCosmosDbCollectionParameters = @{
                    Context         = $script:testContext
                    Id              = $script:testCollection1
                    OfferThroughput = 400
                    OfferType       = 'S1'
                }

                { $script:result = New-CosmosDbCollection @newCosmosDbCollectionParameters } | Should -Throw
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -Exactly -Times 0
            }
        }

    }

    Describe 'Remove-CosmosDbCollection' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Remove-CosmosDbCollection -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with context parameter and an Id' {
            $script:result = $null

            Mock `
                -CommandName Invoke-CosmosDbRequest `
                -ParameterFilter { $Method -eq 'Delete' -and $ResourceType -eq 'colls' -and $ResourcePath -eq ('colls/{0}' -f $script:testCollection1) }

            It 'Should not throw exception' {
                $removeCosmosDbCollectionParameters = @{
                    Context = $script:testContext
                    Id      = $script:testCollection1
                }

                { $script:result = Remove-CosmosDbCollection @removeCosmosDbCollectionParameters } | Should -Not -Throw
            }

            It 'Should call expected mocks' {
                Assert-MockCalled `
                    -CommandName Invoke-CosmosDbRequest `
                    -ParameterFilter { $Method -eq 'Delete' -and $ResourceType -eq 'colls' -and $ResourcePath -eq ('colls/{0}' -f $script:testCollection1) } `
                    -Exactly -Times 1
            }
        }
    }
}
