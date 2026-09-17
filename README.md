# Cabo Espichel — semnul din piatră

O pagină web autonomă despre promontoriul **Cabo Espichel** (Sesimbra, Portugalia), unde adânciturile din peretele falezei sunt cinstite de cel puțin șase secole ca urmele copitelor catârcei pe care Maica Domnului a urcat din mare — și sunt, tot ele, icnofosile de sauropode vechi de aproape o sută cincizeci de milioane de ani.

Pagina nu alege între cele două propoziții: ele răspund la întrebări diferite.

<table>
  <tr>
    <td width="50%" valign="top"><img src="docs/desktop-luminos.png" alt="Pagina întreagă, pe desktop"></td>
    <td width="50%" valign="top"><img src="docs/mobil-luminos.png" alt="Pagina întreagă, pe telefon, tăiată în trei coloane"></td>
  </tr>
  <tr>
    <td align="center"><sub><b>Desktop</b> — 1280px, pagina întreagă</sub></td>
    <td align="center"><sub><b>Telefon</b> — 375px, pagina întreagă, așezată în trei coloane</sub></td>
  </tr>
</table>

<details>
  <summary>Aceleași două, în tema întunecată</summary>
  <table>
    <tr>
      <td width="50%" valign="top"><img src="docs/desktop-intunecat.png" alt="Pagina întreagă, pe desktop, tema întunecată"></td>
      <td width="50%" valign="top"><img src="docs/mobil-intunecat.png" alt="Pagina întreagă, pe telefon, tema întunecată"></td>
    </tr>
  </table>
  <p><sub>Pagina urmează tema sistemului: nu are comutator, se schimbă singură după <code>prefers-color-scheme</code>.</sub></p>
</details>

## Cum se deschide

Un singur fișier, `index.html`, fără nicio dependență externă — nici bibliotecă, nici font, nici imagine de pe alt server. Se deschide offline, dintr-un dublu-click.

## Ce conține

O **poveste centrală** scurtă, precedată de o bandă cu reperele locului — de la urmele lăsate acum vreo sută patruzeci și cinci de milioane de ani până la prima echipă de cercetare, în 1971.

Sub ea, **optsprezece secțiuni** care se deschid în ferestre modale: geologia falezei și cum a ajuns înclinată, urmele de dinozauri și cercetarea lor de până în 2025, trecerile preistorice, romane și islamice, documentele medievale, tradiția locului, animalul care poartă, urma în piatră în tradiția creștină, cartea naturii, frica și frumusețea, rânduiala celor douăzeci și șase de sate, ce s-a zidit acolo, cine a ținut locul, marea și farul, citirea fosilelor înainte de paleontologie, Nazaré, cronologia și limitele dosarului — plus informația practică de teren.

Fereastra deschisă își ține minte unde ai rămas: un cartonaș citit pe jumătate se redeschide de acolo, cât ține vizita.

## Cum se citește

Fiecare afirmație e marcată, iar distincția e ținută peste tot:

| Marcaj | Înseamnă |
|---|---|
| **F** | fapt documentat, verificat în cel puțin o sursă primară sau științifică |
| **F?** | fapt probabil, dintr-o singură sursă, neverificat independent |
| **D** | dispută reală între specialiști |
| **T** | ce s-a păstrat prin tradiție — povestire, nu document |
| **I** | citire, nu fapt |
| **✗** | afirmație care circulă și care este falsă sau nesusținută |

## Versiuni

### 0.0.4

Două schimbări, în două commit-uri. `11a7043` aduce README-ul rescris pe versiuni și cele patru capturi ale întregii pagini din `docs/` — desktop și telefon, în temă luminoasă și întunecată.

Commit-ul pe care stă eticheta scoate din secțiunea „Ce nu se poate spune" mențiunea despre sebastianism. Rămân neatinse corectura despre Camões, Pessoa și Almada Negreiros, cea despre versul gravat la Cabo da Roca, și poetul Sebastião da Gama — care e altceva decât mitul, chiar dacă poartă același nume.

### 0.0.3 — `126612a`

Fereastra modală ține minte poziția de citire. Un cartonaș deschis prima oară pornește de sus; unul deschis a doua oară se redeschide exact unde a rămas cititorul, cât ține vizita.

Poziția se reține pe măsură ce se derulează, nu la închidere — la închidere `<dialog>` e deja ascuns, iar `scrollTop` al unui element ascuns se citește 0. Așa sunt acoperite toate căile de închidere: butonul, Esc și clicul pe fundal.

### 0.0.2 — `40e4eea`

Scoasă secțiunea „Capete de lume", tabelul care compara promontoriul cu alte capete de lume. Cartonașele s-au renumerotat singure, de la 19 la 18, fiindcă numărul e calculat din poziție.

Corectura despre versul *„onde a terra se acaba e o mar começa"* — gravat la Cabo da Roca, fără legătură cu Espichel — trăia numai în tabelul scos, așa că a fost mutată în secțiunea „Ce nu se poate spune".

### 0.0.1 — `7297996`

Prima publicare: pagina autonomă, cu povestea centrală, nouăsprezece secțiuni în ferestre modale și marcajele de fiabilitate pe fiecare afirmație.

<sub>Fiecare versiune are eticheta ei în depozit: `v0.0.1`, `v0.0.2`, `v0.0.3`, `v0.0.4`.</sub>

## Despre sanctuar

Espichel este un sanctuar marian romano-catolic portughez, aflat astăzi în grija Diecezei de Setúbal. Faptele sunt redate ca atare; cinstirea Maicii Domnului e numită însă cu vocabularul ortodox al cititorului căruia îi e scrisă pagina.

## Surse

Pagina e construită dintr-un dosar documentar propriu, cu bibliografie primară și științifică: cartografia geologică 1:50.000 (foaia 38-B Setúbal) și Kullberg et al. (2013) pentru tectonică; Lockley, Meyer & dos Santos (*Gaia* 10, 1994) pentru turma de sauropode juvenile; Antunes & Mateus (*C. R. Palevol* 2, 2003); Figueiredo et al. (2021–2025) pentru cercetarea recentă; Figueiredo & Carvalho (2014) pentru preistorie; Strabon III.1.4 și III.3.1 pentru sursele antice; plus documentele și sursele de epocă ale sanctuarului — atestarea din 1366, *Santuário Mariano* (1707) și Frei Cláudio da Conceição (1817).
