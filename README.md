# getdatafromISS
semi automatic digitization of ISS plot
semi automatic digitization of ISS plot
Alcuni grafici prodotti dall'ISS sul report periodico sono basati su dati non accessibili digitalmente.
Questo codice per Matlab permette di digitalizzare i grafici con una affidabilità soddisfacente.
L'immagine corrispondente al grafico dovrebbe includere gli assi e ed essere ad alta risoluzione.
Il codice chiede di cliccareare su due punti dell'asse y e dell'asse x e di scrivere i corrispondenti valori sulla finestra di testo.
Bisogna infine selezionare l'are dell'immagine che contiene i dati, escludendo assi ed altro.
I dati vengono conservati in un file di tipo csv che può essere riletto utilizzando la funzione in read_digitized_table.m

In cima al file digitize.m si trovano i parametri modificabili dall'utente.
Le barre del plot vengono identificate in base al colore. I parametri relativi sono contenuti nella funzione createMask_blu_bars2.m.
Quest'ultima è stata ottenuta automaticamente utilizzando la app colorThresholder di Matlab.
