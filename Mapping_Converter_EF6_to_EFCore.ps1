# 
# This script is converting the mappings from EF6 to EF Core
# (Some additional manual work might be required)
# 
# Main rules examples:
# .HasRequired(userAccount => userAccount.GlobalizationUserLanguage) --> builder.HasOne(userAccount => userAccount.GlobalizationUserLanguage) + .IsRequired()
# .HasOptional(calibrator => calibrator.Migration)                   --> builder.HasOne(calibrator => calibrator.Migration)


Clear-Host
$DirPath = "C:\_Dev\Mappings" # put the mappings to convert in this directory
$file = get-childitem $DirPath -recurse -include *.cs 

foreach ($name in $file)
{
    $nameShort = $name.Name.substring(0,$name.Name.length -10)
    Write-Output $nameShort

    $find = 'return config;'
    $replace = ''
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = 'WillCascadeOnDelete(false);'
    $replace = 'OnDelete(DeleteBehavior.NoAction);'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = 'HasOptional'
    $replace = 'HasOne'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = '.HasRequired'
    $replace = '.IsRequired()'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = '.HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);'
    $replace = '.ValueGeneratedNever();'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = 'public partial class MappingsCore'
    $tmp = 'public class ' +  $nameShort + 'Configuration : IEntityTypeConfiguration<' +  $nameShort + '>'
    $replace = $tmp
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $tmp1 = 'public static EntityTypeConfiguration<' + $nameShort  + '> Create' + $nameShort  + 'Configuration()'
    $find = $tmp1
    $tmp2 = 'public void Configure(EntityTypeBuilder<' + $nameShort + '> builder)'
    $replace = $tmp2
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $tmp1 = '> builder)()'
    $find = $tmp1
    $tmp2 = '> builder)'
    $replace = $tmp2
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace [regex]::escape($find),$replace } | Set-Content $name.PSPath

    $tmp3 = 'EntityTypeConfiguration<' + $nameShort + '> config = new EntityTypeConfiguration<' + $nameShort + '>();'
    $find = $tmp3
    $replace = ''
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace [regex]::escape($find),$replace } | Set-Content $name.PSPath

    $tmp3 = 'config.ToTable("' + $nameShort +'", MappingConfig.Current.Schema);'
    $find = $tmp3
    $replace = ''
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace [regex]::escape($find),$replace } | Set-Content $name.PSPath

    $find = 'using System.Data.Entity.ModelConfiguration;'
    $replace = 'using Microsoft.EntityFrameworkCore;'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $find = 'using System.ComponentModel.DataAnnotations.Schema;'
    $replace = 'using Microsoft.EntityFrameworkCore.Metadata.Builders;'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath

    $token = 'config.'
    $find = "\b$token\b"
    $replace = 'builder.'
    (Get-Content $name.PSPath) | Foreach-Object { $_ -replace $find,$replace } | Set-Content $name.PSPath 

}
