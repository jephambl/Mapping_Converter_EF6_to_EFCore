# Mapping_Converter_EF6_to_EFCore
Simple powershell script to convert mappings from EF6 to EF Core

# This script is a starting point to bulk convert the mappings from EF6 to EF Core
# Some additional manual work might be required

# Main rules examples:
# .HasRequired(userAccount => userAccount.GlobalizationUserLanguage) --> builder.HasOne(userAccount => userAccount.GlobalizationUserLanguage) + .IsRequired()
# .HasOptional(calibrator => calibrator.Migration)                   --> builder.HasOne(calibrator => calibrator.Migration)
