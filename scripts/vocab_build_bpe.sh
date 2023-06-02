#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..



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




echo "mission accomplished"
