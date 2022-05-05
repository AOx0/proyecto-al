build_remote: && open
    cd .. && scp -r proyecto kali:~
    ssh kali  "pwd && cd ~/proyecto && just build 1 1 && exit"
    cd .. && scp kali:~/proyecto/test.pdf proyecto
    
open:
    qil Preview
    open test.pdf -a Preview    

build stage="1" mac="0":
    {{if stage == "1" {"just pre_stage"} else { "echo 'Precompile'" } }}
    {{if stage == "1" { "biber test" } else { "echo 'Skipped biber test'" } }}
    pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -shell-escape test.tex
    {{if stage == "1" { "rm -rf _minted-test .texpadtmp/ bibliography.bib.bbl bibliography.bib.blg" } else { "echo 'Skipping'" } }}
    {{if stage == "1" { "rm -rf test.aux test.bbl test.bcf test.blg test.log test.run.xml test.synctex.gz" } else { "echo 'Skipping'" } }}
    {{if mac == "0" { "qil Preview; open test.pdf -a Preview" } else { "echo 'Skipping'" } }}

    
pre_stage:
    just build 0 1 
