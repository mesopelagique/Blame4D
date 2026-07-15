//%attributes = {}
// Colorize 4D code as multi-style text (<span> tags), theme aware.
// Meant as a list box column data source when the column has "styledText" enabled.
#DECLARE($code : Text)->$styled : Text

$styled:=cs.Highlighter.me.highlight($code)
