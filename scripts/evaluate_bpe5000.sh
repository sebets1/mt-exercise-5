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

model_name=transformer_sample_config_bpe-level_5000

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-de.$src > $translations_sub/test.$model_name.$trg

# compute case-sensitive BLEU 

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.ro-de.$trg


echo "time taken:"
echo "$SECONDS seconds"
