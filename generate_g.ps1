# Build icons
Invoke-Expression "dart run flutter_iconpicker:generate_packs --packs material"

# Generate .g.dart files if needed
Invoke-Expression "dart run build_runner build --delete-conflicting-outputs"
