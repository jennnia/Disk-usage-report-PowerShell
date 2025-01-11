# Function to analyze disk usage and generate report
function Analyze-DiskUsage {
	param(
			[string]$directoryPath
	     )

		Write-Host "Directory path received: $directoryPath"

# Validate the directory path
		if (-Not (Test-Path -Path $directoryPath)) {
			Write-Host "Invalid directory path."
				return
		}

# Initialize a hashtable to store file sizes by extension
	$fileSizeByExtension = @{}

# Recursively scan the files in the directory and subdirectories
	$files = Get-ChildItem -Path $directoryPath -Recurse -File

		foreach ($file in $files) {
			$extension = $file.Extension.ToLower()

# Skip files with no extension
				if ($extension -eq "") {
					continue
				}

# Add file size to the respective extension
			if ($fileSizeByExtension.ContainsKey($extension)) {
				$fileSizeByExtension[$extension] += $file.Length
			} else {
				$fileSizeByExtension[$extension] = $file.Length
			}
		}

# Sort the results by file size in descending order
	$sortedResults = $fileSizeByExtension.GetEnumerator() | Sort-Object -Property Value -Descending

# Display the results in the console
		Write-Host "Disk Usage Report by File Extension:"
		foreach ($result in $sortedResults) {
			Write-Host "$($result.Key): $([math]::round($result.Value / 1MB, 2)) MB"
		}

# Save the results to a file
	$outputPath = ".\disk_usage_report.txt"
		$sortedResults | ForEach-Object {
			"$($_.Key): $([math]::round($_.Value / 1MB, 2)) MB"
		} | Out-File -FilePath $outputPath

	Write-Host "Disk usage report saved to $outputPath"
}

# Main script execution
if ($args.Count -eq 0) {
# Prompt user for directory if no argument is provided
	$directoryPath = Read-Host "Enter the directory path"
} else {
# Use the directory path from the command-line argument
	$directoryPath = $args[0]
}

# Call the function to analyze disk usage
Analyze-DiskUsage -directoryPath $directoryPath
