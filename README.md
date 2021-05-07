# Blame4D

[![language][code-shield]][code-url]
[![language-top][code-top]][code-url]
![code-size][code-size]
[![release][release-shield]][release-url]
[![license][license-shield]][license-url]
[![discord][discord-shield]][discord-url]

Parse `git blame -p` result into objects

## How to

```4d
$blame:=blame($blameOut)
```
with `$blameOut` the result of the git blame operation using -p (porcelain) option.

For instance `git blame -p 'Project/Sources/Classes/Blame.4dm'`

> You could launch git command with `LAUNCH EXTERNAL PROCESS`

### Get lines and commit data

```4d
// Get the commit data object
$commitData = $blame.commitData

// Get the line data object
// each item containing a reference(the hash) to commits that can be then referenced in commitData
$lineData = $blame.lineData
```

### Get data for a specific line

```4d
$lineData = $blame.data(5) 
```

It's equivalient to `$lineData["5"]` merged with `$commitData[$lineData["5"].hash]`

## Acknowledgement

Code converted from Javascript project [blamejs](https://github.com/mnmtanish/blamejs)   with [Mesopotamia](https://github.com/mesopelagique/Mesopotamia)

## Other components

[<img src="https://mesopelagique.github.io/quatred.png" alt="mesopelagique"/>](https://mesopelagique.github.io/)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[code-shield]: https://img.shields.io/static/v1?label=language&message=4d&color=blue
[code-top]: https://img.shields.io/github/languages/top/mesopelagique/Blame4D.svg
[code-size]: https://img.shields.io/github/languages/code-size/mesopelagique/Blame4D.svg
[code-url]: https://developer.4d.com/
[release-shield]: https://img.shields.io/github/v/release/mesopelagique/Blame4D
[release-url]: https://github.com/mesopelagique/Blame4D/releases/latest
[license-shield]: https://img.shields.io/github/license/mesopelagique/Blame4D
[license-url]: LICENSE.md
[discord-shield]: https://img.shields.io/badge/chat-discord-7289DA?logo=discord&style=flat
[discord-url]: https://discord.gg/dVTqZHr
