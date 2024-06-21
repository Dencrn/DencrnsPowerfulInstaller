# Load the required .NET types
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# Define the XAML for the GUI
$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Dencrn's Powerful Installer" WindowState="Maximized">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <UniformGrid Rows="1" HorizontalAlignment="Stretch" VerticalAlignment="Top" Margin="10" Grid.Row="0">
            <Button Name="WebBrowsers" Content="Web Browsers" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Communications" Content="Communications" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Security" Content="Security" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Runtimes" Content="Runtimes" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Imaging" Content="Imaging" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Documents" Content="Documents" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Torrenting" Content="Torrenting" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Compression" Content="Compression" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="Utilities" Content="Utilities" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="GameLaunchers" Content="Game Launchers" Margin="5" HorizontalAlignment="Stretch"/>
            <Button Name="OnlineStorage" Content="Online Storage" Margin="5" HorizontalAlignment="Stretch"/>
        </UniformGrid>
        
        <StackPanel Name="ContentPanel" Grid.Row="1" Margin="10" HorizontalAlignment="Stretch" VerticalAlignment="Stretch">
            <!-- Placeholder for dynamic content -->
        </StackPanel>
        
        <Button Name="InstallButton" Content="Install" Grid.Row="2" Margin="10" HorizontalAlignment="Right" VerticalAlignment="Bottom" IsEnabled="False" FontSize="16" Width="150" Height="50"/>
    </Grid>
</Window>
"@


# Load the XAML
$XamlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($XAML))
$Window = [Windows.Markup.XamlReader]::Load($XamlReader)
$ContentPanel = $Window.FindName("ContentPanel")
$InstallButton = $Window.FindName("InstallButton")

# Dictionary to store checkbox states
$global:CheckBoxStates = @{}

# Define the dictionary to store checkbox states
$global:CheckBoxStates = @{}

# Function to create checkboxes
# Define the dictionary to store checkbox states
$global:CheckBoxStates = @{}

# Load the XAML
$XamlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($XAML))
$Window = [Windows.Markup.XamlReader]::Load($XamlReader)
$ContentPanel = $Window.FindName("ContentPanel")
$InstallButton = $Window.FindName("InstallButton")

function CreateCheckBoxes {
    param (
        [string]$category,
        [array]$apps
    )

    # Clear existing content in ContentPanel
    $ContentPanel.Children.Clear()

    # Check if CheckBoxStates is null and initialize it if so
    if (-not $global:CheckBoxStates) {
        $global:CheckBoxStates = @{}
    }

    # Check if the category exists in CheckBoxStates and initialize it if not
    if (-not $global:CheckBoxStates.ContainsKey($category)) {
        $global:CheckBoxStates[$category] = @{}
    }

    $label = New-Object System.Windows.Controls.Label
    $label.Content = "Select applications for $category"
    $ContentPanel.Children.Add($label)

    foreach ($app in $apps) {
        $checkBox = New-Object System.Windows.Controls.CheckBox
        $checkBox.Content = "$category - $app"
        
        # Set checkbox state if previously saved
        if ($global:CheckBoxStates[$category].ContainsKey($app)) {
            $checkBox.IsChecked = $global:CheckBoxStates[$category][$app]
        }

        # Save checkbox state on click
        $checkBox.Add_Checked({
            if (-not $global:CheckBoxStates[$category]) {
                $global:CheckBoxStates[$category] = @{}
            }
            $global:CheckBoxStates[$category][$app] = $true
            UpdateInstallButtonState
        })

        $checkBox.Add_Unchecked({
            if (-not $global:CheckBoxStates[$category]) {
                $global:CheckBoxStates[$category] = @{}
            }
            $global:CheckBoxStates[$category][$app] = $false
            UpdateInstallButtonState
        })

        $ContentPanel.Children.Add($checkBox)
    }
}

# Event handlers for category buttons
$Window.FindName("WebBrowsers").Add_Click({
    CreateCheckBoxes -category "Web Browsers" -apps $WebBrowsersApps
})

# Define the list of applications for each category
$WebBrowsersApps = @("Chrome", "Firefox", "Edge", "Safari")
$CommunicationsApps = @("Skype", "Zoom", "Slack", "Discord")
$SecurityApps = @("Antivirus", "Firewall", "VPN", "Password Manager")
$RuntimesApps = @("Java", ".NET Framework", "Adobe AIR", "Unity")
$ImagingApps = @("Photoshop", "GIMP", "Illustrator", "Inkscape")
$DocumentsApps = @("Microsoft Office", "Google Docs", "OpenOffice")
$TorrentingApps = @("uTorrent", "BitTorrent", "qBittorrent", "Transmission")
$CompressionApps = @("WinRAR", "7-Zip", "WinZip", "PeaZip")
$UtilitiesApps = @("CCleaner", "WinDirStat", "PuTTY", "Notepad++")
$GameLaunchersApps = @("Steam", "Epic Games Launcher", "Origin", "Uplay")
$OnlineStorageApps = @("Dropbox", "Google Drive", "OneDrive", "iCloud")

# Event handlers for category buttons
$Window.FindName("WebBrowsers").Add_Click({
    CreateCheckBoxes -category "Web Browsers" -apps $WebBrowsersApps
})

$Window.FindName("Communications").Add_Click({
    CreateCheckBoxes -category "Communications" -apps $CommunicationsApps
})

$Window.FindName("Security").Add_Click({
    CreateCheckBoxes -category "Security" -apps $SecurityApps
})

$Window.FindName("Runtimes").Add_Click({
    CreateCheckBoxes -category "Runtimes" -apps $RuntimesApps
})

$Window.FindName("Imaging").Add_Click({
    CreateCheckBoxes -category "Imaging" -apps $ImagingApps
})

$Window.FindName("Documents").Add_Click({
    CreateCheckBoxes -category "Documents" -apps $DocumentsApps
})

$Window.FindName("Torrenting").Add_Click({
    CreateCheckBoxes -category "Torrenting" -apps $TorrentingApps
})

$Window.FindName("Compression").Add_Click({
    CreateCheckBoxes -category "Compression" -apps $CompressionApps
})

$Window.FindName("Utilities").Add_Click({
    CreateCheckBoxes -category "Utilities" -apps $UtilitiesApps
})

$Window.FindName("GameLaunchers").Add_Click({
    CreateCheckBoxes -category "Game Launchers" -apps $GameLaunchersApps
})

$Window.FindName("OnlineStorage").Add_Click({
    CreateCheckBoxes -category "Online Storage" -apps $OnlineStorageApps
})

# Define the event handler for the Install button
$InstallButton.Add_Click({
    # Your installation logic here
    # For now, let's display a message box
    [System.Windows.MessageBox]::Show("Installation started...")
})

# Function to update the Install button state
function UpdateInstallButtonState {
    $installEnabled = $false

    foreach ($categoryApps in $global:CheckBoxStates.Values) {
        foreach ($appState in $categoryApps.Values) {
            if ($appState) {
                $installEnabled = $true
                break
            }
        }
        if ($installEnabled) {
            break
        }
    }

    $InstallButton.IsEnabled = $installEnabled
}

# Show the main window
$Window.ShowDialog() | Out-Null