
# Mapping Converter form EF6 to EFCore

Simple powershell script to convert the Entity Framework mappings from EF6 to EF Core.

## What it does? 

This script is a starting point to bulk convert the mappings from EF6 to the EF Core format.

Some additional manual work might be required, but it will be useful if you have a lot of entities to migrate.

## How it works? 
1. Make a backup of your mappings.
2. Put the mappings to convert in this directory: "C:\_Dev\Mappings".
3. Run the script and the mappings in "C:\_Dev\Mappings" will be modified to work with EF Core.

## FAQ

#### What are the main conversion rules?

- HasRequired is becoming HasOne and you must add IsRequired to your mapping
- HasOptional is becoming HasOne (without adding IsRequired in this case)

Example:
```bash
.HasRequired(userAccount => userAccount.GlobalizationUserLanguage) 
    --> builder.HasOne(userAccount => userAccount.GlobalizationUserLanguage) 
                .... 
               .IsRequired()

.HasOptional(calibrator => calibrator.Migration) 
    --> builder.HasOne(calibrator => calibrator.Migration)
```

## Badges

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
