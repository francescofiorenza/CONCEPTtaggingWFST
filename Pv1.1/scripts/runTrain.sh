#!/bin/bash
mkdir -p ../output
#Conto le occorrenze dei campioni appartenenti alle diverse classi(Concetti)
./trainCONCEPT/1CONCEPTcountCreate.sh > ../output/CONCEPT.counts
#Conto le occorrenze del valore del campione dato che appartiene alla classe t_i (POS)
./trainCONCEPT/2TOK_CONCEPTcountCreate.sh > ../output/TOK_CONCEPT.counts
#Descrivo la macchina a stati finiti che passa dallo stato 0 allo stato 0 ad un ingresso di TOK e un uscita di CONCEPT 
#con peso della transizione pari al -log(probabilità di TOK w_i appartenente alla classe t_i POS)
./trainCONCEPT/3CONCEPTtaggerWFSTCreate.sh >../output/CONCEPTtaggerFST.txt
#Generiamo il lessico tramite ngramsymbols (appartiene al pacchetto openfst)
ngramsymbols < ../data/NLSPARQL.train.data >../output/lex.txt
#Compiliamo il nostro trasduttore a stati finiti tramite il lessico e che ci permetterà di convertire la frase in 
#input in una sequenza di Concetti (insomma ci permette di taggare ogni parola)
fstcompile --isymbols=../output/lex.txt --osymbols=../output/lex.txt --unknown_symbol='<unk>' ../output/CONCEPTtaggerFST.txt > ../output/CONCEPTtagger.fst
fstarcsort ../output/CONCEPTtagger.fst>../output/CONCEPTtagger.fst
#Dato che il training non è mai esaustivo, ci possono essere delle parole non note che devono
#essere mappate. Per mappare una parola non nota in uno dei possibili 41 CONCEPT
#definiamo una macchina a stati finiti che va da <unk> a uno dei possibili POS 
#con una probabilità di 1 su 41 (-l(1 / 41)|bc -l)=-log(1/41)
./trainCONCEPT/4CONCEPTtaggerUnknownTOKENCreate.sh >../output/CONCEPTtaggerUnknownTokenFST.txt
fstcompile --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/CONCEPTtaggerUnknownTokenFST.txt>../output/CONCEPTtaggerUnknownToken.fst
#A questo punto uniamo i due trasduttori cosicchè la macchina finale cerchi di tradurre anche i caratteri non noti
fstunion ../output/CONCEPTtaggerUnknownToken.fst ../output/CONCEPTtagger.fst>../output/finalCONCEPTtagger.fst
##	Se vogliamo testiamo la nostra macchina finale con la frase 'star of thor' decommentiamo le prossime righe
#mkdir -p ../output/temp
#./trainCONCEPT/check/sentence2fsa.sh 'star of thor'>../output/temp/sent.txt
#fstcompile --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/sent.txt>../output/temp/sent.fst
#fstcompose ../output/temp/sent.fst ../output/finalCONCEPTtagger.fst > ../output/temp/composeSentCONCEPTtagger.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtagger.fst>../output/temp/composeSentCONCEPTtagger.dot
#xdot ../output/temp/composeSentCONCEPTtagger.dot 2>/dev/null
#fstrmepsilon ../output/temp/composeSentCONCEPTtagger.fst>../output/temp/composeSentCONCEPTtaggerRMeps.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerRMeps.fst > ../output/temp/composeSentCONCEPTtaggerRMeps.dot
#xdot ../output/temp/composeSentCONCEPTtaggerRMeps.dot  2>/dev/null
#fstshortestpath ../output/temp/composeSentCONCEPTtaggerRMeps.fst >../output/temp/composeSentCONCEPTtaggerRMepsSP.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerRMepsSP.fst > ../output/temp/composeSentCONCEPTtaggerRMepsSP.dot
#xdot ../output/temp/composeSentCONCEPTtaggerRMepsSP.dot 2>/dev/null
##	Ora vogliamo generalizzare con un il modello di Marcov e integrare anche la probabilità condizionata alla 
##classe precedente. 
##quindi tramite il convertitore token per line a sentence per line "convTPL2SPL.sh" generiamo frasi di concetti
##generiamo per ogni riga. Ogni riga è composta solo da concetti così da calcolarne la statistica di essi. 
##In automatico il comando farcompilestrings presente nello script farcompile.sh con anche convTPL2SPL.sh genera una fst per
##ogni riga e la mette nell'archivio. Il l'archivio di CONCEPT.far verrà utilizzato per calcolare gli ngram di vario ordine
##Come tecnica di smoothing è stata utilizzata quella di default witten_bell
##final state archive e mette ogni frase in una macchina a stati e poi l'impacchetta tutte assieme
./trainCONCEPT/5CONCEPTfarCREATE.sh ../output/CONCEPTtrain.far
order=3
method=witten_bell
ngramcount --order=$order --require_symbols=false ../output/CONCEPTtrain.far > ../output/CONCEPT.cnt
ngrammake --method=$method ../output/CONCEPT.cnt > ../output/CONCEPT.lm
##Una volta che ho il modello lo posso utilizzare per generare la mia macchina a stati finiti che consideri 
##anche le scelte fatte per gli elementi vicini
##	Se vogliamo testiamo la nostra macchina finale con la frase 'star of thor' decommentiamo le prossime righe
#fstcompose ../output/temp/sent.fst ../output/finalCONCEPTtagger.fst |
#fstcompose - ../output/CONCEPT.lm>../output/temp/composeSentCONCEPTtaggerLM.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerLM.fst > ../output/temp/concSentTaggerCONCEPTlm.dot
#xdot ../output/temp/concSentTaggerCONCEPTlm.dot 2>/dev/null
#fstrmepsilon ../output/temp/composeSentCONCEPTtaggerLM.fst>../output/temp/composeSentCONCEPTtaggerLMRMeps.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerLMRMeps.fst >../output/temp/composeSentCONCEPTtaggerLMRMeps.dot
#xdot ../output/temp/composeSentCONCEPTtaggerLMRMeps.dot 2>/dev/null 
#fstshortestpath ../output/temp/composeSentCONCEPTtaggerLMRMeps.fst > ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.fst
#fstdraw --isymbols=../output/lex.txt --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.fst > ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.dot
#xdot ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.dot 2>/dev/null
#fstprint ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.fst
#fsttopsort ../output/temp/composeSentCONCEPTtaggerLMRMepsSP.fst>../output/temp/composeSentCONCEPTtaggerLMRMepsSPts.fst
#fstprint  --isymbols=../output/lex.txt  --osymbols=../output/lex.txt ../output/temp/composeSentCONCEPTtaggerLMRMepsSPts.fst
