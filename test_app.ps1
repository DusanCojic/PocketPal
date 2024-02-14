# Test app script for Windows

# Call generator first
. ".\generate_g.ps1"

# Run the test
Invoke-Expression "flutter test"