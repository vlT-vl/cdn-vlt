# cdn-vlt

CDN to serve static file for vlT projects 

per eseguire script da remoto è sufficente eseguire uno dei comandi di seguito:

####  linux 
###### &rarr; contiene script di deployment linux vlt

###### debian13-init
```curl -fsSL https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/linux/debian13-init | bash -s``` \
&rarr; accetta parametri: --base | --vlt | --work

es: curl -fsSL "URL_del_tuo_script" | bash -s -- [parametro]

####  s2e 
###### &rarr; contiene tutto il necessario su CDN per automation deployment S2E

####  windows 
###### &rarr; contiene script di deployment windows vlt

###### basewindows-vlt

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/vlt-basewindows.ps1' | iex```

###### otherapps-vlt

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/vlt-otherapps.ps1' | iex```
 
###### sellscript

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/vlt-sellscript.ps1' | iex```


###### retelit deploy

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/vlt-retelit-deploy.ps1' | iex```

###### s2e deploy

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/vlt-s2e-deploy.ps1' | iex```

###### winactivate

```irm 'https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/windows/winactivate.ps1' | iex```


Copyright © 2025 vlT di Veronesi Lorenzo. Tutti i diritti sono riservati.
