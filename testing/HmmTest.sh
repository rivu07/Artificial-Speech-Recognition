# !/bin/bash

julia_path='../../../../bin' #change this
model_path='../test' #change this
hmm_path='../model'

set -e

#audio file handling 
mkdir "audio/train"
mv "audio/wav" "audio/train/"
mkdir "audio/train/sowav"
mkdir "audio/train/mfcc"

#nist to riff conversion
cd "audio/train/wav/"
find "." -name "*.WAV" | parallel -P20 sox {} "../sowav/{.}.wav"
cd ../../..

#creating codetrain.scp 
python3 codetrainscpCreate.py

#creating mfcc files
HCopy -A -D -T 1 -C wav_config -S codetrain.scp 

mv "audio/train/mfcc" "$model_path/"
mv "audio/train/wav" "audio/"
rm -r "audio/train"




#creating train.scp
python3 "trainscpCreate.py" "$model_path/"
mv "train.scp" "$model_path/train.scp"


#creating wlist file
julia "$julia_path/prompts2wlist.jl" "allsentences" "$model_path/wlist"

#better now than never
cp "config" "$model_path/"
cp "proto" "$model_path/"
cp "sil.hed" "$model_path/"
cp "mktri.led" "$model_path/"
cp "maketriphones.ded" "$model_path/"
cp "tree.hed" "$model_path/"
cp "global.ded" "$model_path/"
cp "mkphones0.led" "$model_path/"
cp "mkphones1.led" "$model_path/"
cp "sentences.txt" "$model_path/"
cp "timitdictupd" "$model_path/"
cp "maketrainscp.py" "$model_path/" 
cp "config2" "$model_path/" 
cp "dictmonophones" "$model_path/"
cp "gram" "$model_path/"


#change directory to model
cd "$model_path"



#creating dict and monophones1 files
HDMan -A -D -T 1 -m -w "wlist" -n "monophones1" -i -l "dlog" "dict" "timitdictupd"
	
#removing sp and creating monophones0 file
sed "/sp/d" "monophones1" > "monophones0"

#creating words.mlf file
julia "$julia_path/prompts2mlf.jl" "sentences.txt" "words.mlf"

#creating phones0.mlf file
HLEd -A -D -T 1 -l "*" -d "dict" -i "phones0.mlf" "mkphones0.led" "words.mlf"

#creating phones1.mlf file
HLEd -A -D -T 1 -l "*" -d "dict" -i "phones1.mlf" "mkphones1.led" "words.mlf"


#python3 "maketrainscp.py" 

cp -r "$hmm_path/hmm15" "."
cp "$hmm_path/tiedlist" "."

HParse "gram" "wdnet"

HVite -C "config2" -H "hmm15/hmmdefs" -H "hmm15/macros" -S "train.scp" -l '*' -i "recout.mlf" -w "wdnet" -p "0.0" -s "5.0" "dictmonophones" "tiedlist"   

HResults -p -I "phones0.mlf" "monophones0" "recout.mlf" > "confusionMatrix"
