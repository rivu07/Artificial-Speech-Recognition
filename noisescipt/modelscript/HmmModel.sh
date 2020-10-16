# !/bin/bash

julia_path='../../../../bin' #change this
model_path='../model' #change this


set -e

#audio file handling 
mkdir "audio/train"
mv "audio/wav" "audio/train/"
mkdir "audio/train/sowav"
mkdir "audio/train/mfcc"

#nist to riff conversion
cd "audio/train/wav/"
find "." -name "*.wav" | parallel -P20 sox {} "../sowav/{.}.wav"
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

#create hmm0
mkdir hmm0


#create proto and vFloors
HCompV -A -D -T 1 -C config -f 0.01 -m -S train.scp -M hmm0 proto

#create hmmdefs
for word in $(cat "monophones0"); do
	echo "~h \"$word\"" >> "hmm0/hmmdefs";
	sed -n "5,$ p" "hmm0/proto" >> "hmm0/hmmdefs";
done


#create macro
sed -n "1,3 p" "hmm0/proto" >> "hmm0/macros"
cat "hmm0/vFloors" >> "hmm0/macros"


#create hmm1-9
for i in {1..9}; do
	mkdir "hmm$i";
done


#create data for hmm1,hmm2,hmm3
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 monophones0



#copy contents of folder hmm3 to hmm4
cp hmm3/* hmm4/


#all the modifications in hmm4
linenumber=$(sed -n "/sil/=" hmm3/hmmdefs)
sed -n "$linenumber,$ p" "hmm3/hmmdefs" > "hmm4/temp"

lines=($(sed -n "/<STATE>/=" "hmm4/temp"))
let lines[1]--
sed "${lines[0]},${lines[1]} d" "hmm4/temp" > "hmm4/temp1"
lines=($(sed -n "/<STATE>/=" "hmm4/temp1"))
last=$(sed -n "/<TRANSP>/=" "hmm4/temp1")
sed "${lines[1]},${last} d" "hmm4/temp1" > "hmm4/temp2"  

rm "hmm4/temp1"
rm "hmm4/temp"

line1=$(sed -n "/<MEAN>/=" "hmm4/temp2")
line2=$(sed -n "/<GCONST>/=" "hmm4/temp2")
sed -n "$line1,$line2 p" "hmm4/temp2" > "hmm4/temp"

rm "hmm4/temp2"

echo "~h \"sp\"" >> "hmm4/hmmdefs"
echo "<BEGINHMM>" >> "hmm4/hmmdefs"
echo "<NUMSTATES> 3" >> "hmm4/hmmdefs"
echo "<STATE> 2" >> "hmm4/hmmdefs"
cat "hmm4/temp" >> "hmm4/hmmdefs"
echo "<TRANSP> 3" >> "hmm4/hmmdefs"
echo " 0.0 1.0 0.0" >> "hmm4/hmmdefs"
echo " 0.0 0.9 0.1" >> "hmm4/hmmdefs"
echo " 0.0 0.0 0.0" >> "hmm4/hmmdefs"
echo "<ENDHMM>" >> "hmm4/hmmdefs"

rm "hmm4/temp"



HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm5/macros -H  hmm5/hmmdefs -M hmm6 monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 monophones1


HVite -A -D -T 1 -l "*" -o SWT -b SENT-END -C config -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I words.mlf -S train.scp dict monophones1> HVite_log
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8 monophones1 
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9 monophones1


HLEd -A -D -T 1 -n triphones1 -l "*" -i wintri.mlf mktri.led aligned.mlf


julia "$julia_path/mktrihed.jl" monophones1 triphones1 mktri.hed


for i in {10..15}; do
	mkdir "hmm$i";
done

HHEd -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -M hmm10 mktri.hed monophones1 
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm10/macros -H hmm10/hmmdefs -M hmm11 triphones1 
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -s stats -S train.scp -H hmm11/macros -H hmm11/hmmdefs -M hmm12 triphones1 


HDMan -A -D -T 1 -b sp -n fulllist0 -g maketriphones.ded -l flog dict-tri dict
julia "$julia_path/fixfulllist.jl" fulllist0 monophones0 fulllist
HHEd -A -D -T 1 -H hmm12/macros -H hmm12/hmmdefs -M hmm13 tree.hed triphones1 
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm13/macros -H hmm13/hmmdefs -M hmm14 tiedlist
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm14/macros -H hmm14/hmmdefs -M hmm15 tiedlist



