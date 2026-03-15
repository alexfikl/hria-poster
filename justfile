TEXMK := "latexmk"
TEXOUTDIR := "latex.out"
TEXFLAGS := "-pdflua -output-directory=" + TEXOUTDIR

_default:
    @just template

[private]
pdf basename:
    {{ TEXMK }} {{ TEXFLAGS }} {{ basename }}.tex
    {{ TEXMK }} {{ TEXFLAGS }} {{ basename }}.tex
    @cp {{ TEXOUTDIR }}/{{ basename }}.pdf .

[doc("Build template example")]
template:
    @just pdf template

[doc("Compile assets for example")]
preview: template
    magick \
        -verbose \
        -density 300 \
        template.pdf \
        -quality 100 \
        -flatten \
        -sharpen 0x1.0 \
        -geometry 2048x \
        template.png

[doc("Update license text")]
license:
    python -m reuse download CC-BY-4.0 MIT
    cp LICENSES/CC-BY-4.0.txt LICENSE
    cp LICENSES/MIT.txt LICENSE.MIT
    @rm -rf LICENSES

[doc("Trim a given logo")]
trim logo:
    magick {{ logo }}.png -trim +repage {{ logo }}.png

[doc("Create a convenient zip file with the template files")]
zip:
    zip -r "$(basename $(pwd)).zip" assets *.sty template.tex

[doc("Remove temporary compilation files")]
clean:
    rm -rf {{ TEXOUTDIR }}
    rm -rf *.aux *.log *.out

[doc("Remove all generated files")]
purge: clean
    rm -rf *.pdf
    rm -rf *.zip
