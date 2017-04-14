#mkdir -p trainfeats
cd trainfeats
#Conto le occorrenze dei campioni appartenenti alle diverse classi(Concetti)
./1POScountCreate.sh > POS.counts
#Conto le occorrenze del valore del campione dato che appartiene alla classe t_i (POS)
./2TOK_POScountCreate.sh > TOK_POS.counts
#Descrivo la macchina a stati finiti che passa dallo stato 0 allo stato 0 ad un ingresso di TOK e un uscita di POS 
#con peso della transizione pari al -log(probabilità di TOK w_i appartenente alla classe t_i POS)
./3POStaggerWFSTCreate.sh >POStaggerFST.txt
#Generiamo il lessico tramite ngramsymbols (appartiene al pacchetto openfst)
ngramsymbols < ../data/NLSPARQL.train.feats.txt >lex.txt
#Compiliamo il nostro trasduttore a stati finiti tramite il lessico e che ci permetterà di convertire la frase in 
#input in una sequenza di Concetti (insomma ci permette di taggare ogni parola)
fstcompile --isymbols=lex.txt --osymbols=lex.txt POStaggerFST.txt|
fstarcsort - > POStagger.fst
#Dato che il training non è mai esaustivo, ci possono essere delle parole non note che devono
#essere mappate. Per mappare una parola non nota in uno dei possibili N POS
#definiamo una macchina a stati finiti che va da <unk> a uno dei possibili POS 
#con una probabilità di 1 su N (-l(1 / N)|bc -l)=-log(1/N)
./4POStaggerUnknownTOKENCreate.sh >POStaggerUnknownFST.txt
fstcompile --isymbols=lex.txt --osymbols=lex.txt POStaggerUnknownFST.txt|
fstarcsort - >POStaggerUnknown.fst
#A questo punto uniamo i due trasduttori cosicchè la macchina finale cerchi di tradurre anche i caratteri non noti
fstunion POStaggerUnknown.fst POStagger.fst|
fstarcsort - >finalPOStagger.fst
fstarcsort finalPOStagger.fst >finalPOStagger.fst
#Testiamo la nostra macchina finale con la frase 'star of thor'
./sentence2fsa.sh 'star of thor'>sent.txt
fstcompile --isymbols=lex.txt --osymbols=lex.txt sent.txt|
fstarcsort - >sent.fst
fstcompose sent.fst finalPOStagger.fst > composeSentPOStagger.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStagger.fst>composeSentPOStagger.dot
xdot composeSentPOStagger.dot &
fstrmepsilon composeSentPOStagger.fst>composeSentPOStaggerRMeps.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStaggerRMeps.fst >composeSentPOStaggerRMeps.dot
xdot composeSentPOStaggerRMeps.dot 
fstshortestpath composeSentPOStaggerRMeps.fst >composeSentPOStaggerRMepsSP.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStaggerRMepsSP.fst >composeSentPOStaggerRMepsSP.dot
xdot composeSentPOStaggerRMepsSP.dot

#ora vogliamo integrare anche la probabilità condizionata alla classe precedente. Markov field.
#quindi tramite il convertitore token per line a sentence per line "convTPL2SPL.sh" generiamo per ogni riga
#una frase composta solo dai sui tag per poi calcolarne la statistica su di essi. Per generare il file far
#si utilizza il comando farcompilestrings presente nello script farcompile.sh con anche convTPL2SPL.sh
# su tale file far andiamo a trainare il nostro modello pos.far tramite gli ngram di ordine 3 o più e poi
#colmando tutti gli zeri con un witten bel
#con lo script farcompile.sh (comprende convTPL2LPS.sh e farcompilestrings) genero il far su cui poi estraggo i ngram counts
#final state archive e mette ogni frase in una macchina a stati e poi l'impacchetta tutte assieme
./farcompiletrainfeats.sh datatrainfeats.far
ngramcount --order=3 --require_symbols=false datatrainfeats.far > POS.cnt
ngrammake --method=witten_bell POS.cnt > POS.lm
#una volta che ho il modello lo posso utilizzare per generare la mia macchina a stati finiti che consideri 
#anche la probabilità di marcov
fstcompose sent.fst finalPOStagger.fst |
fstcompose - POS.lm>composeSentPOStaggerLM.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStaggerLM.fst > concSentTaggerPOSlm.dot
xdot concSentTaggerPOSlm.dot
fstrmepsilon composeSentPOStaggerLM.fst>composeSentPOStaggerLMRMeps.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStaggerLMRMeps.fst >composeSentPOStaggerLMRMeps.dot
xdot composeSentPOStaggerLMRMeps.dot 
fstshortestpath composeSentPOStaggerLMRMeps.fst >composeSentPOStaggerLMRMepsSP.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentPOStaggerLMRMepsSP.fst >composeSentPOStaggerLMRMepsSP.dot
xdot composeSentPOStaggerLMRMepsSP.dot
fstprint composeSentPOStaggerLMRMepsSP.fst
fsttopsort composeSentPOStaggerLMRMepsSP.fst>composeSentPOStaggerLMRMepsSPts.fst
fstprint  --isymbols=lex.txt  --osymbols=lex.txt composeSentPOStaggerLMRMepsSPts.fst
