#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=ro
trg=de


num_threads=4
device=0

# measure time

SECONDS=0

model_name=transformer_sample_config_bpe-level_2000

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/beam_size_experiments
beam_size=5
output_file=bpe_beam-size_${beam_size}

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-de.$src > $translations_sub/$output_file.$trg

## remove first line with "sentence" to make hyp and ref equal length
#
#tail -n +2 $translations_sub/$output_file.$trg > $translations_sub/$output_file.clean.$trg
#mv $translations_sub/$output_file.clean.$trg $translations_sub/$output_file.$trg

# compute case-sensitive BLEU

cat $translations_sub/$output_file.$trg | sacrebleu $data/test.ro-de.$trg


echo "time taken:"
echo "$SECONDS seconds"
