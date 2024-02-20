## Comandi per abilitare statistiche di performance native (FreeRTOS)

Prima di tutto abilitare la funzionalità mettendo a 1 `configUSE_TRACE_FACILITY` nel file di configurazione `FreeRTOSConfig.h`.

Si presuppone che le variabili del tipo `TaskHandle_t tskHand`, per contenere gli handle dei vari task, siano dichiarate globali all'inizio del codice.

### Esempi utili
#### Stampare il nome del task corrente
All'interno di un task:
```c
    tskHand = xTaskGetCurrentTaskHandle();
    printf("The task %s is running \r\n", pcTaskGetName(tskHand));
```
#### Ottenere lo stato di un task
```c
eTaskState mioStato;
mioStato = eTaskGetState(tskHand);
printf("The state of the task is %d\r\n", mioStato);
```
Il file `task.h` contiene le spiegazioni dei numeri che possono essere stampati:

|  Intero ritornato   | Significato    |
| --- | --- |
|  0   |  Running   |
|  1   |   Ready  |
|  2  |   Blocked  |
|  3   |  Suspended   |
|  4   |  Deleted   |
|  5   |   Invalid  |

#### Ottenere statistiche sui task ad un dato momento
> Si presuppone di aver dichiarato la variabile globale `char buffer[*numero_bytes*]` da usare come write buffer (tipicamente lungo 300).

> Si presuppone di aver posto ad `1` i seguenti parametri del file `FreeRTOSConfig.h`: `configSUPPORT_DYNAMIC_ALLOCATION`, `configUSE_TRACE_FACILITY` e `configUSE_STATS_FORMATTING_FUNCTIONS`.
La funzione `void vTaskListTasks( char *pcWriteBuffer, size_t uxBufferLength )` presenta in formato ASCII informazioni sullo stato dei task.
Esempio di utilizzo:
```c
vTaskListTasks(buffer,lunghezza_buffer);
printf("%s\r\n", buffer);
```
Il risultato sarà una tabella con una riga per ogni task del sistema, che segue lo schema del tipo:
```
nome_task |	stato(B,R,D,S)	|	priorità	|	stack high water mark	|	"turno" per essere eseguito
```
(B = blocked, R = ready, D = waiting for cleanup, deleted, S = suspended (i.e. blocked indefinitely)).
Lo stack high water mark è praticamente quanto manca prima di esaurire lo spazio dello stack che è stato assegnato al task.

#### Ottenere una misurazione del tempo in tick
La funzione `xTaskGetTickCount( void );` restituisce quanti tick dell'orologio sono passati da quando si è avviato lo scheduler con `vTaskStartScheduler`.
Esempio:
```c
printf("Il task xxx è in esecuzione al momento del tick %ld\r\n", xTaskGetTickCount());
```
> Attenzione: non usare questa funzione all'interno di una Interrupt Service Routine. Usa xTaskGetTickCountFromISR() in quel caso.

---
