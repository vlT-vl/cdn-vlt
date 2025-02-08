#########################################################################################################################################################
# s2e deploymentform script
#########################################################################################################################################################

Add-Type -AssemblyName PresentationFramework

# Percorso del file locale
$filePath = "$env:USERPROFILE\deployment-s2e.log"

# Creazione della finestra
$window = New-Object System.Windows.Window
$window.Title = "Deployment Completato"
$window.Width = 400
$window.Height = 150
$window.WindowStartupLocation = "CenterScreen"

# Creazione del contenitore StackPanel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = "Vertical"
$stackPanel.Margin = 10

# Creazione dell'etichetta con il messaggio
$label = New-Object System.Windows.Controls.TextBlock
$label.Text = "il Deploy del PC è stato completato"
$label.Margin = "0,0,0,10"
$label.FontSize = 14
$label.TextAlignment = "Center"

# Creazione del link al file
$link = New-Object System.Windows.Controls.TextBlock
$link.Text = "Apri il file di log"
$link.FontSize = 14
$link.Foreground = "Blue"
$link.TextDecorations = [System.Windows.TextDecorations]::Underline
$link.Cursor = "Hand"
$link.HorizontalAlignment = "Center"

# Aggiunta dell'evento click per aprire il file
$link.AddHandler([System.Windows.UIElement]::MouseLeftButtonUpEvent,
    [System.Windows.Input.MouseButtonEventHandler]{
        param($sender, $args)
        Start-Process $filePath
    })

# Pulsante per chiudere la finestra
$button = New-Object System.Windows.Controls.Button
$button.Content = "Chiudi"
$button.Width = 80
$button.Margin = "0,10,0,0"
$button.HorizontalAlignment = "Center"
$button.Add_Click({ $window.Close() })

# Aggiunta degli elementi al contenitore
$stackPanel.Children.Add($label)
$stackPanel.Children.Add($link)
$stackPanel.Children.Add($button)

# Aggiunta del contenitore alla finestra
$window.Content = $stackPanel

# Mostra la finestra
$window.ShowDialog()
