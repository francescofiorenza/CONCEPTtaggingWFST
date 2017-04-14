#Conto le occorrenze dei campioni appartenenti alle diverse classi(Concetti)
./1CONCEPTcountCreate.sh > CONCEPT.counts
#Conto le occorrenze del valore del campione dato che appartiene alla classe t_i (POS)
./2TOK_CONCEPTcountCreate.sh > TOK_CONCEPT.counts
#Descrivo la macchina a stati finiti che passa dallo stato 0 allo stato 0 ad un ingresso di TOK e un uscita di CONCEPT 
#con peso della transizione pari al -log(probabilità di TOK w_i appartenente alla classe t_i POS)
./3CONCEPTtaggerWFSTCreate.sh >CONCEPTtaggerFST.txt
#Generiamo il lessico tramite ngramsymbols (appartiene al pacchetto openfst)
ngramsymbols < data/NLSPARQL.train.data >lex.txt
#Compiliamo il nostro trasduttore a stati finiti tramite il lessico e che ci permetterà di convertire la frase in 
#input in una sequenza di Concetti (insomma ci permette di taggare ogni parola)
fstcompile --isymbols=lex.txt --osymbols=lex.txt CONCEPTtaggerFST.txt > CONCEPTtagger.fst
#Dato che il training non è mai esaustivo, ci possono essere delle parole non note che devono
#essere mappate. Per mappare una parola non nota in uno dei possibili 41 CONCEPT
#definiamo una macchina a stati finiti che va da <unk> a uno dei possibili POS 
#con una probabilità di 1 su 41 (-l(1 / 41)|bc -l)=-log(1/41)
./4CONCEPTtaggerUnknownTOKENCreate.sh >CONCEPTtaggerUnknownFST.txt
fstcompile --isymbols=lex.txt --osymbols=lex.txt CONCEPTtaggerUnknownFST.txt>CONCEPTtaggerUnknown.fst
#A questo punto uniamo i due trasduttori cosicchè la macchina finale cerchi di tradurre anche i caratteri non noti
fstunion CONCEPTtaggerUnknown.fst CONCEPTtagger.fst>finalCONCEPTtagger.fst
#Testiamo la nostra macchina finale con la frase 'star of thor'
./sentence2fsa.sh 'star of thor'>sent.txt
fstcompile --isymbols=lex.txt --osymbols=lex.txt sent.txt>sent.fst
fstcompose sent.fst finalCONCEPTtagger.fst > composeSentCONCEPTtagger.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtagger.fst>composeSentCONCEPTtagger.dot
xdot composeSentCONCEPTtagger.dot &
fstrmepsilon composeSentCONCEPTtagger.fst>composeSentCONCEPTtaggerRMeps.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtaggerRMeps.fst >composeSentCONCEPTtaggerRMeps.dot
xdot composeSentCONCEPTtaggerRMeps.dot 
fstshortestpath composeSentCONCEPTtaggerRMeps.fst >composeSentCONCEPTtaggerRMepsSP.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtaggerRMepsSP.fst >composeSentCONCEPTtaggerRMepsSP.dot
xdot composeSentCONCEPTtaggerRMepsSP.dot
#ora vogliamo integrare anche la probabilità condizionata alla classe precedente. Markov field.
#quindi tramite il convertitore token per line a sentence per line "convTPL2SPL.sh" generiamo per ogni riga
#una frase composta solo dai sui tag per poi calcolarne la statistica su di essi. Per generare il file far
#si utilizza il comando farcompilestrings presente nello script farcompile.sh con anche convTPL2SPL.sh
# su tale file far andiamo a trainare il nostro modello pos.far tramite gli ngram di ordine 3 o più e poi
#colmando tutti gli zeri con un witten bel
#con lo script farcompile.sh (comprende convTPL2LPS.sh e farcompilestrings) genero il far su cui poi estraggo i ngram counts
#final state archive e mette ogni frase in una macchina a stati e poi l'impacchetta tutte assieme
./farcompiletrain.sh datatrain.far
ngramcount --order=3 --require_symbols=false datatrain.far > CONCEPT.cnt
ngrammake --method=witten_bell CONCEPT.cnt > CONCEPT.lm
#una volta che ho il modello lo posso utilizzare per generare la mia macchina a stati finiti che consideri 
#anche la probabilità di marcov
fstcompose sent.fst finalCONCEPTtagger.fst |
fstcompose - CONCEPT.lm>composeSentCONCEPTtaggerLM.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtaggerLM.fst > concSentTaggerCONCEPTlm.dot
xdot concSentTaggerCONCEPTlm.dot
fstrmepsilon composeSentCONCEPTtaggerLM.fst>composeSentCONCEPTtaggerLMRMeps.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtaggerLMRMeps.fst >composeSentCONCEPTtaggerLMRMeps.dot
xdot composeSentCONCEPTtaggerLMRMeps.dot 
fstshortestpath composeSentCONCEPTtaggerLMRMeps.fst >composeSentCONCEPTtaggerLMRMepsSP.fst
fstdraw --isymbols=lex.txt --osymbols=lex.txt composeSentCONCEPTtaggerLMRMepsSP.fst >composeSentCONCEPTtaggerLMRMepsSP.dot
xdot composeSentCONCEPTtaggerLMRMepsSP.dot
fstprint composeSentCONCEPTtaggerLMRMepsSP.fst
fsttopsort composeSentCONCEPTtaggerLMRMepsSP.fst>composeSentCONCEPTtaggerLMRMepsSPts.fst
fstprint  --isymbols=lex.txt  --osymbols=lex.txt composeSentCONCEPTtaggerLMRMepsSPts.fst
