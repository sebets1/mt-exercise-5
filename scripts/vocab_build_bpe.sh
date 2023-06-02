#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..
#merge_ops=2000
#src=train_100k.ro
#trg=train_100k.de
#src_lang=ro
#trg_lang=de




# -------------------------
train_file=train_100k
num_operations=5000
L1=ro
L2=de
vocab_file=vocab_bpe
codes_file=codesfile_bpe.${num_operations}


echo "learning BPE..."

# Learn byte pair encoding on the concatenation of the training text, and get resulting vocabulary for each
cat ${base}/data/${train_file}.${L1} ${base}/data/${train_file}.${L2} | subword-nmt learn-bpe -s ${num_operations} -o ${base}/data/${codes_file}
subword-nmt apply-bpe -c ${base}/data/${codes_file} < ${base}/data/${train_file}.${L1} | subword-nmt get-vocab > ${base}/data/${vocab_file}_${num_operations}.${L1}
subword-nmt apply-bpe -c ${base}/data/${codes_file} < ${base}/data/${train_file}.${L2} | subword-nmt get-vocab > ${base}/data/${vocab_file}_${num_operations}.${L2}

echo "applying BPE..."
# re-apply byte pair encoding with vocabulary filter
subword-nmt apply-bpe -c ${base}/data/${codes_file} --vocabulary ${base}/data/${vocab_file}_${num_operations}.${L1}  --vocabulary-threshold 50 < ${base}/data/${train_file}.${L1}  > ${base}/data/${train_file}.BPE.L1
subword-nmt apply-bpe -c ${base}/data/${codes_file} --vocabulary ${base}/data/${vocab_file}_${num_operations}.${L2}  --vocabulary-threshold 50 < ${base}/data/${train_file}.${L2}  > ${base}/data/${train_file}.BPE.L2

python3 ${base}/scripts/vocab_bpe_clean.py ${base}/data/${vocab_file}_${num_operations}.${L1} ${base}/data/${vocab_file}_${num_operations}.${L2} ${base}/data/vocab_bpe_${num_operations}.txt ${num_operations}

# -------------------------
#echo "learning * joint * BPE..."
#
## concatenate the source and target language train files and save them into new file
#cat ${base}/data/${src} ${base}/data/${trg} > ${base}/data/bpe/vocab_bpe.tmp
#python3 -m subword_nmt.learn_bpe -s $merge_ops -i ${base}/data/bpe/vocab_bpe.tmp -o ${codes_file}
#rm ${base}/data/bpe/vocab_bpe.tmp
#
## I first had this line with the --total-symbols flag but somehow got only 1700 tokens, so I took it out
##python3 -m subword_nmt.learn_bpe -s $merge_ops --total-symbols -i ${base}/data/bpe/vocab_bpe.tmp -o ${codes_file}
#
#
#echo "applying BPE..."
#
#
#for l in ${src_lang} ${trg_lang}; do
#  python3 -m subword_nmt.apply_bpe -c ${codes_file} -i ${base}/data/train_100k.${l} -o ${base}/data/bpe/train.bpe.${merge_ops}.${l}
#  python3 -m subword_nmt.apply_bpe -c ${codes_file} -i ${base}/data/dev.ro-de.${l} -o ${base}/data/bpe/dev.bpe.${merge_ops}.${l}
#  python3 -m subword_nmt.apply_bpe -c ${codes_file} -i ${base}/data/test.ro-de.${l} -o ${base}/data/bpe/test.bpe.${merge_ops}.${l}
#  cat ${base}/data/bpe/train.bpe.${merge_ops}.${l} >> ${bpe_output}
#  cat ${base}/data/bpe/dev.bpe.${merge_ops}.${l} >> ${bpe_output}
#  cat ${base}/data/bpe/test.bpe.${merge_ops}.${l} >> ${bpe_output}
#done


# -------------------------
#
#for l in ${src} ${trg}; do
#    for p in train valid test; do
#        python3 -m subword_nmt.apply_bpe -c ${codes_file} -i ${base}/data/${p}.${l} -o ${base}/data/${p}.bpe.${merge_ops}.${l}
#    done
#done

echo "mission accomplished"
