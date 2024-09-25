# Instruktioner för koduppgiften

Uppgiften går ut på att skriva ett program som läser in en fil i ett format, konverterar till ett annat format och sparar den konverterade filen på disk.

## Filerna

Du hittar inputfilerna i projektet under mappen `artefakter`. I undermappen `resultat` har du även de förväntade resultaten till hjälp.

## Formaten

Inputfilernas format representerar något slags medborgarförslag och beskrivs som följande:

```
Titel: [string]
Avsändare: [string]
Beskrivning: [string]
```

Anonyma ärenden förekommer och då är värdet höger om `Avsändare:` tomt (se `./artefakter` för exempel).

Outputfilen bör vara en XML-fil och se ut på följande sätt:

```xml
<Ärende>
    <Rubrik></Rubrik>
    <Beskrivning></Beskrivning>
</Ärende>
```

Elementet `<Rubrik>` bör innehålla en textsträng som följer mallen:

`Förslag om {Titel} inskickad av {Avsändare}`

Där `{Titel}` hämtas från värdet i input-filens `Titel:`-rad och `{Avsändare}` från värdet i input-filens `Avsändare:`-rad. Om ingen avsändare finns bör det stå `Anonym` istället. Om flera avsändare står med på ett förslag så bör deras namn separeras av `,` förutom näst sista och sista namnen som bör separeras av partikeln `och`. Exempel:

`Förslag om något inskickad av Anonym`

`Förslag om något annat inskickad av Leif och Hanna`

`Förslag om annat inskickad av Adam, Ronja och Basel`

Elementet `<Beskrivning>` bör innehålla värdet höger om `Beskrivning:` från input-filen.


### Exempel

Om inputfilen innehåller:

```
Titel: Parkbänkar
Avsändare: Ulf Ulfsson, Basel Adra
Beskrivning: Vore trevligt med lite bänkar i parken så vi kan sätta oss och ta en lunch.
```

Så bör filen ditt program skapar innehålla:

```xml
<Ärende>
    <Rubrik>Förslag om Parkbänkar inskickad av Ulf Ulfsson och Basel Adra</Rubrik>
    <Beskrivning>Vore trevligt med lite bänkar i parken så vi kan sätta oss och ta en lunch.</Beskrivning>
</Ärende>
```

## Förväntningar

Din uppgift är alltså att skriva ett program som läser in en fil. Programmet bör parsa filen, konvertera datan och skapa en ny fil i xml-format med den konverterade datan. Du väljer själv hur du åstadkommer detta. Det är alltså fritt fram att använda vilka tekniker du vill, men du bör hålla dig till följande riktlinjer:

1. Programmet bör inte läsa in filer från hårdkodade sökvägar. Med andra ord, programmet bör kunna ta emot en av användaren specifierad sökväg till filen som den ska läsa in, t.ex. genom ett argument eller parameter till ett script, en konfigurationsfil, eller en widget i ett ui. Hur exakt det sker är upp till dig.
2. Skriv gärna instruktioner om hur vi kan köra din lösning eller skicka med en docker compose fil.
3. Programmet bör gå att köra i Windows 10 eller ett Debian-baserat OS (det är okej om lösningen kräver Docker, men skicka då med en docker compose fil).

Du är välkommen att höra av dig med frågor när som helst. Lycka till!
