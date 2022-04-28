@build_remote:
    #! /bin/zsh
    cd ..
    scp -r proyecto kali:~
    ssh kali "pwd && cd ~/proyecto && just build 1 && exit"
    scp kali:~/proyecto/test.pdf proyecto
    qil Preview
    open proyecto/test.pdf -a Preview    

build stage="1":
    {{if stage == "1" {"just pre_stage"} else { "echo 'Precompile'" } }}
    {{if stage == "1" { "biber test" } else { "echo 'Skipped biber test'" } }}
    pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -shell-escape test.tex
    {{if stage == "1" { "rm -rf _minted-test .texpadtmp/ bibliography.bib.bbl bibliography.bib.blg" } else { "echo 'Skipping'" } }}
    {{if stage == "1" { "rm -rf test.aux test.bbl test.bcf test.blg test.log test.run.xml test.synctex.gz" } else { "echo 'Skipping'" } }}
    
pre_stage:
    just build 0
